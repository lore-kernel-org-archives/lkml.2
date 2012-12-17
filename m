Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2LQOOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 09:14:36 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47024 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab2LQOOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 09:14:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAL1gcdMyx4y0TeSRi+5oG6cpULPXGu+i8E0ej3-6+n9pt8qPSw@mail.gmail.com>
References: <20686.63778.840426.61474@pilspetsen.it.uu.se>
	<CAHdPZaPQNQ1WS5Qkb4FpmmOX7mXL10HsdaXf5dctp2hd2T0Sow@mail.gmail.com>
	<20687.3736.365327.811519@pilspetsen.it.uu.se>
	<CAHdPZaNOK=isKPZtxYaBFsGvcpN0261wExaXgRYjg5N3Y7qJZg@mail.gmail.com>
	<CAL1gcdMyx4y0TeSRi+5oG6cpULPXGu+i8E0ej3-6+n9pt8qPSw@mail.gmail.com>
Date: Mon, 17 Dec 2012 09:14:33 -0500
Message-ID: <CAHdPZaPq6em+mRSoJ1SJMi++J9rAObgtt2e1sXqqFOqbeDctAg@mail.gmail.com>
Subject: Re: [3.7.0 regression] rt2x00lib_probe_dev: Error - Failed to
 initialize hw
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is caused by the introduction of interface combinations. Helmut
> Schaa has already submitted a patch to fix this, but this has
> unfortunately not ended up in 3.7. I'm confident it will end up in one
> of the upcoming 3.7.x stable releases.
>
> See http://marc.info/?l=linux-wireless&m=135478723823922&w=2 for the
> patch submitted by Helmut.
> ---
> Gertjan


thanks for the info, it seems that it fixes Mikael's problem.
