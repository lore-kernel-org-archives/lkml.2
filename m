Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab1FPKpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 06:45:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55007 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1FPKpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 06:45:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=SrL/GT95P7V2IaQHU4ha7p42LnJq2/r0QKdEDOA6FZ3gcSYX8iiqPAAzZJOWhtmFgy
         ARsJPfFsGMsiOxFZzB7D5WYWue7OQxiMiSQCFrU1tgwSHqMuZ9/ZOQ7eIqXPsyHLTbG8
         mAfgIFsRf7hCJPZ7nx30br9ng4tvJEoNA0JCw=
From: Jordi Pujol <jordipujolp@gmail.com>
To: Erez Zadok <ezk@fsl.cs.sunysb.edu>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
Date: Thu, 16 Jun 2011 12:45:27 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-1.jpp.10-lnet-amd64; KDE/4.6.3; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "viro@ZenIV.linux.org.uk Viro" <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        mszeredi@suse.cz, "J. R. Okajima" <hooanon05@yahoo.co.jp>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu> <4540f7aa16724111bd792a1d577261c2@HUBCAS1.cs.stonybrook.edu> <954F11FF-339B-48E2-8358-A158DE1E53BC@fsl.cs.sunysb.edu>
In-Reply-To: <954F11FF-339B-48E2-8358-A158DE1E53BC@fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201106161245.28256.jordipujolp@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Dijous, 16 de juny de 2011 08:51:39, Erez Zadok va escriure:
> (A) USEFULNESS OF UNIONING:
> 
> Unioning is a very useful feature,

like an user of union filesystem modules I completely agree with Erez opinions.

I will say that Overlayfs responds to the needs of a Live system, both for 
daily operations and for making a new remaster also.

It is true that Overlayfs is a young program, and these last few days have 
been found some small problems that Miklos has solved promptly.

According to developers, it is assumed that there are other issues, such as  
links, or the modification of the lower branches of filesystems, etc; but they 
do not appear in a Live system that has been properly prepared taking into 
account those limitations, already documented.

Overlayfs now works correctly, I use it on some computers on a daily basis and 
have not found any problems.

Currently I install all my Linux computers in hard drive copying a file that 
contains the compressed operating system, then the computer uses an union file 
system to boot; that has many advantages and some drawbacks, one of these is 
that the programmer must wait for the corresponding version of the union 
module while a new version of the kernel has been already released; Overlayfs 
has greatly simplified source code and an average user can adapt it to a new 
version making small changes.

For this type of installation no more characteristics are needed in Overlayfs, 
the next step would be to include it in kernel as a staging module. This way 
people will refine some details of its operation and later maybe could add some 
other functionality.

Thanks,

Jordi Pujol

Live never ending Tale
GNU/Linux Live forever!
http://livenet.selfip.com
