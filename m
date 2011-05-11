Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab1EKPrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:47:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37107 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab1EKPrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:47:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QVc/FEH5ylCLbzCaoGoxYbKktVtvC1NBfNYhRNHnKm6GVM6plCmls+jXdc7LFeVPr7
         3TL6tiT0ACyiTqsGnsMuU+EeQcUmzn2U+ZKX68lYxBi+HOO/ze72Lxaw+9vj1Mq3QW9v
         B0n/zbWz5S89sxvR9+0lfMRMWcEkgDGAJ76mE=
MIME-Version: 1.0
In-Reply-To: <4DC98489.2060902@candelatech.com>
References: <4DC98489.2060902@candelatech.com>
Date: Wed, 11 May 2011 12:16:51 +0200
Message-ID: <BANLkTinTFSX2yZeqnBVtshSVwho+Lyr32Q@mail.gmail.com>
Subject: Re: Fedora 14 not always going to run-level 3?
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 8:31 PM, Ben Greear <greearb@candelatech.com> wrote:
> Has anyone else noticed problems with 39-rc1+ sometimes not booting
> into run-level 3?  It seems to just go directly to root console prompt
> sometimes.  Seems it was easier to reproduce on -rc1 and early more
> buggy kernels, for what that's worth..

Haven't seen this one - F14 always booted into runlevel 3 on my Dell
 Latitude E6400... and since I save all my kernel .config files I can tell
 you which kernels I've tested:

[root@duff src]# ls  .config-2.6.39-rc*
.config-2.6.39-rc1       .config-2.6.39-rc3-git3  .config-2.6.39-rc4-git8
.config-2.6.39-rc1-git1  .config-2.6.39-rc3-git4  .config-2.6.39-rc5
.config-2.6.39-rc1-git2  .config-2.6.39-rc3-git6  .config-2.6.39-rc5-git1
.config-2.6.39-rc1-git3  .config-2.6.39-rc3-git7  .config-2.6.39-rc5-git2
.config-2.6.39-rc1-git5  .config-2.6.39-rc4       .config-2.6.39-rc5-git4
.config-2.6.39-rc2       .config-2.6.39-rc4-git1  .config-2.6.39-rc5-git6
.config-2.6.39-rc2-git1  .config-2.6.39-rc4-git2  .config-2.6.39-rc5-git7
.config-2.6.39-rc2-git2  .config-2.6.39-rc4-git4  .config-2.6.39-rc6
.config-2.6.39-rc2-git3  .config-2.6.39-rc4-git5  .config-2.6.39-rc6-git2
.config-2.6.39-rc3       .config-2.6.39-rc4-git6  .config-2.6.39-rc6-git6
.config-2.6.39-rc3-git1  .config-2.6.39-rc4-git7  .config-2.6.39-rc7

[root@duff ~]# grep "^id" /etc/inittab
id:3:initdefault:

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
