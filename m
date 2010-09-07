Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab0IGNZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 09:25:01 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33956 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab0IGNY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 09:24:56 -0400
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
CC: miklos@szeredi.hu, hch@infradead.org, viro@zeniv.linux.org.uk,
        adilger@sun.com, corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu,
        linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
In-reply-to: <m3d3spvhdn.fsf@linux.vnet.ibm.com>
	(aneesh.kumar@linux.vnet.ibm.com)
Subject: Re: [PATCH -V19 00/15] Generic name to handle and open by handle syscalls
References: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <m31v95zweh.fsf@linux.vnet.ibm.com> <E1OswT5-000709-U9@pomaz-ex.szeredi.hu> <m3d3spvhdn.fsf@linux.vnet.ibm.com>
Message-Id: <E1OsyA1-0007Ct-KS@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 07 Sep 2010 15:24:29 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Sep 2010, Aneesh Kumar K. V wrote:
> On Tue, 07 Sep 2010 13:36:03 +0200, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > On Tue, 07 Sep 2010, Aneesh Kumar K. V wrote:
> > > Any update on this. Are you ok with syscall approach which is limitted to
> > > CAP_DAC_READ_SEARCH  ?
> > 
> > My gut reaction is: "not another bunch of xattr syscalls!".  It
> > doesn't feel right, this interface is too specialized to warrant a
> > full set of filesystem syscalls.
> 
> 
> Are you ok with rest of syscalls other than the handle based xattr one ?

No, not really.  Only xattrs stand out from the rest as the "API that
shouldn't be" and adding more to that pile makes me feel especially
bad.

But xattrs aside, I still don't think we need another interface for
file handles that duplicates the existing filesystem APIs.

Thanks,
Miklos
