Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab0GAUjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:39:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60391 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab0GAUjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:39:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH]kernel.h Move warning message about using kernel headers for userspace to types.h
Date: Thu, 1 Jul 2010 22:38:58 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jkosina@suse.cz
References: <1277935785-6023-1-git-send-email-justinmattock@gmail.com> <201007011707.31783.arnd@arndb.de> <4C2CCE57.40208@gmail.com>
In-Reply-To: <4C2CCE57.40208@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007012238.58335.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/+kbP/UJxWLcb4kvDuMwXrbtKHOhlRV9cngTb
 sIOXm+BRGziOy60Twgsykntu57CSIolCy61I/iwlEoGrawudsc
 IeF2K8mnCdWCtg+qKILPQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 July 2010, Justin P. Mattock wrote:
> o.k. I resent an updated version. keep in mind this is a bit confusing 
> with the __KERNEL__ being in there multiple times, but with the v2 I'm 
> able to see the #warning message with my little program.

Well, it's technically correct, but the #ifndef __KERNEL__ in there
would better get dropped, since you are already in the #else path.

> As for the patch itself hopefully I corrected it's changelog etc..
> lately I've been a bit confused with the whole sighned off thing i.g.
> you suggested the #else so naturally I should add your name with a 
> sighned off, but with other patches I was told not to do so due to the 
> sighned off procedure/process. I'll re-read the submitting patches again 
> to make sure.

You got that part right. The S-o-b only ever gets added by a person
sending a patch for the sending address, so you would not add my
address as S-o-B, though you could add it as Cc:.
When someone picks up your patch and forwards it, that person 
will add his/her own S-o-b line below yours and keep you listed
as From.

	Arnd
