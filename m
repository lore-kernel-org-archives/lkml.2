Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1ATL1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:27:35 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41017 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab1ATL1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:27:32 -0500
To: Gurudas Pai <gurudas.pai@oracle.com>
CC: hughd@google.com, miklos@szeredi.hu, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
In-reply-to: <4D37DAD7.3050100@oracle.com> (message from Gurudas Pai on Thu,
	20 Jan 2011 12:18:55 +0530)
Subject: Re: [BUG] kernel BUG at mm/truncate.c:479! on 2.6.37-rc8
References: <4D1AD935.1020504@oracle.com> <alpine.LSU.2.00.1012291137080.6381@sister.anvils> <4D1C2E86.9000004@oracle.com> <4D37DAD7.3050100@oracle.com>
Message-Id: <E1Pfsfh-0007iL-6X@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 20 Jan 2011 12:27:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011, Gurudas Pai wrote:
> Hi Hugh,
> 
> Gurudas Pai wrote:
> >>> With 2.6.37-rc8 , run a fio test over nfs, with following jobfile, 
> >>> and we
> >>> hit kernel bug.
> >>
> >> Have you tried the same test on earlier releases?
> >> I think the bug is old, yet only recently reported.
> > I tried with 2.6.36.2 , even there it is panicing.
> > 
> > 
> >> This NFS-triggered kernel BUG at mm/truncate.c:479 sounds very like
> >> the FUSE-triggered kernel BUG at mm/truncate.c:475 on 2.6.36.1 for
> >> which Miklos posted a patch on 14 December.  Please give his patch
> >> (below) a try and let us know if it fixes the issue for you - thanks.
> > Issue fixed with the patch, Thanks :)
> 
> Is this patch included in mainline ?

Apparently not.  I'll update the patch and send it to Andrew shorty.

Thanks,
Miklos
