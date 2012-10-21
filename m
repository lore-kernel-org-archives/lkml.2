Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab2JUX5F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 19:57:05 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47374 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab2JUX5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 19:57:03 -0400
Message-ID: <50848BCC.9030208@zankel.net>
Date: Sun, 21 Oct 2012 16:57:00 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the xtensa tree with Linus' tree
References: <20121022104056.d157f09f9c71052ecc1f64a5@canb.auug.org.au>
In-Reply-To: <20121022104056.d157f09f9c71052ecc1f64a5@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Sorry, I accidentally pushed this patch up; should be fixed the next 
next time you pull.

Thanks,
-Chris



On 10/21/2012 04:40 PM, Stephen Rothwell wrote:
> Hi Chris,
>
> Today's linux-next merge of the xtensa tree got a conflict in
> arch/xtensa/include/uapi/asm/unistd.h between commit 7216cabfff51
> ("xtensa: add missing system calls to the syscall table") from Linus'
> tree and commit daff2ab722aa ("xtensa: add missing system calls to the
> syscall table") from the xtensa tree.
>
> These clearly were meant to be the same patch but the on in Linus' tree
> has a later date, so I used it and can carry the fix as necessary (no
> action is required).
>
> Also, the top most commit in the xtensa tree has no signed-off-by line or
> any real commit message.  Please fix that up.
>

