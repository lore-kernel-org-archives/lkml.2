Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab2CLTPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:15:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56715 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab2CLTPs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:15:48 -0400
MIME-Version: 1.0
In-Reply-To: <C6gS2DkSgiG.A.UgC.VuRXPB@chimera>
References: <WuYv90FoNpB.A.O8.ktRXPB@chimera>
	<C6gS2DkSgiG.A.UgC.VuRXPB@chimera>
Date: Mon, 12 Mar 2012 20:15:47 +0100
Message-ID: <CAPVoSvSG3d1ZnY=x-wv=OnXD7Cx9sdSajBXESAWPXkrSrkUdAA@mail.gmail.com>
Subject: Re: [Bug #42678] [3.3-rc1] radeon stuck in kernel after lockup
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        =?ISO-8859-1?Q?J=E9r=F4me_Glisse?= <glisse@freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/11 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 3.2.  Please verify if it still should be listed and let the tracking team
> know (either way).

Still the same state as of 2012/02/04.
The regression (X no longer recovering from GPU lockup) is probably
still there, I'm just no longer seeing it, because the trigger of the
GPU lockups got fixed. (These GPU lockups themselfs were not a
regression wrt. 3.3-rc1, that bug existed at least since 3.1)

> Bug-Entry       : https://bugzilla.kernel.org/show_bug.cgi?id=42678
> Subject         : [3.3-rc1] radeon stuck in kernel after lockup
> Submitter       : Torsten Kaiser <just.for.lkml@googlemail.com>
> Date            : 2012-01-21 19:03 (51 days old)
> Message-ID      : <CAPVoSvSXMvRb=1itu9DjF+s=6zfAChvUxS-x=b8EV9kOZinNpA@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=132717279606670&w=2
> Handled-By      : Jérôme Glisse <glisse@freedesktop.org>
>
>
