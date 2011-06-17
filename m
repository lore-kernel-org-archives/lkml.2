Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab1FQSys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 14:54:48 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58142 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702Ab1FQSyq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 14:54:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=l8qjCh/RR/Id5+GezE3x1/Fy7Tv5fJEbweKbn4+j98PI8Gj+/i2h7dTZfXTQ9S5iyi
         Ura2WU5O4jrx+RwOSUtKZZFmhuTPGLZ9XJvYn3XD02qBMEHDUCQM4eUDvzPUP1IDYzJv
         3JFIwi+IjwSk3qu1l+6ozqf1rvCiLsFb7OCA0=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=NYq7wFqGFuiM_QUtpEZDS5pAuUQ@mail.gmail.com>
References: <BANLkTin8b2suL1675DKvHbeXuCzeCFJeOg@mail.gmail.com>
 <BANLkTin-iYMvbuq=DGo8JZa_vYUMsd24jQ@mail.gmail.com> <BANLkTi=NYq7wFqGFuiM_QUtpEZDS5pAuUQ@mail.gmail.com>
From: Paul Hartman <paul.hartman@gmail.com>
Date: Fri, 17 Jun 2011 13:54:26 -0500
Message-ID: <BANLkTikiszrsC7n-31yUXpMEKHTbWamabw@mail.gmail.com>
Subject: Re: New Gentoo install on Intel Z68/i7-2600K system hangs after
 VFS:Mounted root...
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 1:29 PM, Mark Knecht <markknecht@gmail.com> wrote:
>   We ran memtest86 for an hour. Completed a couple of passes with no
> errors. Will run more later but no obvious memory problems seen.
>
>   I installed 2.6.39-gentoo-r1. No change from 2.6.38-gentoo-r6.
> Stops at the same place.
>
>   I tried 2.6.39-gentoo-r1 with no kernel options, and with all
> combinations of nousb and acpi=off. All 4 attempts quit at the same
> place.

Check out this forum post, this person's bootup seems to stop in the
same place as yours. He was able to fix it by booting off a liveCD and
manually creating device nodes. Maybe it's nothing, but probably worth
looking at just in case it might help.

https://www.linuxquestions.org/questions/gentoo-87/booting-stops-after-kernel-starts-883031/
