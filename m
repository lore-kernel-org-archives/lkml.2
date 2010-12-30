Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab0L3H6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 02:58:17 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52511 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab0L3H6Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 02:58:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VLWv4clmX0jQW3bY7DeQNy9Irc75TEmdPlLFvrpLfyS1WKG3oOnOJfmkF6xZADw2QI
         OV3fAyMX5bBslmI41MnBagSN1NiBIwA1OMafiaNZtbuFO8QhbOd1F2KRylsWL8+pDoAE
         01Omz1lePTkrofg+nNqOhfQBOsuI5ghOm6W8k=
MIME-Version: 1.0
In-Reply-To: <sV7shrPOroO.A.nPF.r-7GNB@chimera>
References: <96DQe4a_2tH.A.4RE.497GNB@chimera>
	<sV7shrPOroO.A.nPF.r-7GNB@chimera>
Date: Thu, 30 Dec 2010 08:58:15 +0100
Message-ID: <AANLkTi=Nik6dRiT2viiCHN6NR6OLApRZSk_z745hM0U8@mail.gmail.com>
Subject: Re: [Bug #24772] Crash with btrfs rootfs on dm-crypt [ kernel BUG at
 fs/btrfs/inode.c:806! ] on linux 2.6.37-rc5
From: Fabio Comolli <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael.
I don't have linux on that laptop anymore.

Regards,
Fabio

On Thu, Dec 30, 2010 at 12:07 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.36.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=24772
> Subject         : Crash with btrfs rootfs on dm-crypt [ kernel BUG at fs/btrfs/inode.c:806! ] on linux 2.6.37-rc5
> Submitter       : Fabio Comolli <fabio.comolli@gmail.com>
> Date            : 2010-12-10 20:30 (20 days old)
> Message-ID      : <AANLkTi=j9zsaYNcu=NgGV=HfE-3rNHzVswov8VrgwjQp@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=129201308706568&w=2
>
>
>
