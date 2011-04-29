Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab1D2PRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:17:01 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33712 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab1D2PQ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:16:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RVQ0cYZCS4sVz9yA4IaBtiTWlGN26MoMYOA80bvyZCQSgdIIOJnuuk+sYA/8HCnZO8
         zwt8vUnPqiKeaWxn+VO5YsFh+otouiZhUoz1Gjh0hAB/Cln/7KKlTIXTeDcN8xCS++Jr
         WvhSgfaf0YJkHCQIN1TwbxywxZZTncY+Io67g=
MIME-Version: 1.0
In-Reply-To: <tip-3d35ac346e981162eeba391e496faceed4753e7b@git.kernel.org>
References: <4D5DFBE4.7090104@intel.com>
	<tip-3d35ac346e981162eeba391e496faceed4753e7b@git.kernel.org>
Date: Fri, 29 Apr 2011 19:16:08 +0400
Message-ID: <BANLkTikf9zUSwJKBbZ+A_6Yu5aeXOtggBQ@mail.gmail.com>
Subject: Re: [tip:x86/trampoline] x86, reboot: Move the real-mode reboot code
 to an assembly file
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        castet.matthieu@free.fr, sfr@canb.auug.org.au, tglx@linutronix.de,
        rjw@sisk.pl, hpa@linux.intel.com
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 08:20, tip-bot for H. Peter Anvin
<hpa@linux.intel.com> wrote:
> Commit-ID:  3d35ac346e981162eeba391e496faceed4753e7b
> Gitweb:     http://git.kernel.org/tip/3d35ac346e981162eeba391e496faceed4753e7b
> Author:     H. Peter Anvin <hpa@linux.intel.com>
> AuthorDate: Mon, 14 Feb 2011 18:36:03 -0800
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Thu, 17 Feb 2011 21:05:34 -0800
>
> x86, reboot: Move the real-mode reboot code to an assembly file
>
> Move the real-mode reboot code out to an assembly file (reboot_32.S)
> which is allocated using the common lowmem trampoline allocator.
>

Hi. This one causes problems on at least a couple HP Compaq laptops:
https://bugzilla.kernel.org/show_bug.cgi?id=33302
