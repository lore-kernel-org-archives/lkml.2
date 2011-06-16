Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab1FPJqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:46:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48591 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757505Ab1FPJqG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:46:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=rFkU1yithLhYX3424AymmUlBNJee6g+6UomPfPJwE43xDbwxuv7Jyo76mrMeo5my31
         SsyBOrZF3Dm2O6PLWiBBZwD+0y0YJbXkG/TcItWVX8ti51687LzP5xzN0lfNpchuFoGM
         nIRtCAIslH2/AmCPbviOORIjMJ2RXGf/7Clw4=
MIME-Version: 1.0
In-Reply-To: <954F11FF-339B-48E2-8358-A158DE1E53BC@fsl.cs.sunysb.edu>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
 <4540f7aa16724111bd792a1d577261c2@HUBCAS1.cs.stonybrook.edu> <954F11FF-339B-48E2-8358-A158DE1E53BC@fsl.cs.sunysb.edu>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Thu, 16 Jun 2011 11:45:45 +0200
X-Google-Sender-Auth: nxFVVJCzidWuRQ6qx2n2gQbLi8E
Message-ID: <BANLkTi=KNL+MiX=R845yz188pTg8hMtRhQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: Erez Zadok <ezk@fsl.cs.sunysb.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "viro@ZenIV.linux.org.uk Viro" <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de,
        jordipujolp@gmail.com, mszeredi@suse.cz,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 June 2011 08:51, Erez Zadok <ezk@fsl.cs.sunysb.edu> wrote:
> On Jun 8, 2011, at 3:32 PM, Andrew Morton wrote:

>
> Val, Jan, Bharata, and others have spent untold amounts of time trying to develop a VFS-based approach.  In lieu of stackable file system approaches, I was hoping to see those VFS-based approaches get the support needed to get merged, and yet they have not.  It appears that development of the VFS-based approaches has stalled, sadly.  To be fair, I have argued before that adding a lot of code to the VFS "just" to support unioning was a bad idea (see http://lkml.org/lkml/2007/12/13/242).  And I also felt that it was going to be hard to support approaches which required changes (however small) to many individual file systems (e.g., to add native whiteout support). But was I'd have been happy to see a VFS-based approach get merged, if the Powers That Be[™] sanctioned it.

Is there any reason why unionmount could not use the xattrs which are
natively supported by most filesystem already like overlayfs does?
That would cut on the sheer number of patches required to get it
working.

Thanks

Michal
