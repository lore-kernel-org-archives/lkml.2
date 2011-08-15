Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab1HOXWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 19:22:52 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33647 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab1HOXWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 19:22:51 -0400
MIME-Version: 1.0
In-Reply-To: <20110815220728.62f27e35@lxorguk.ukuu.org.uk>
References: <CAGRJchidA8ZTMcJnmfJpoBjjpG1zYFC4XQT8KKxjQUm4o3CCng@mail.gmail.com>
	<20110815220728.62f27e35@lxorguk.ukuu.org.uk>
Date: Mon, 15 Aug 2011 17:22:50 -0600
Message-ID: <CAGRJchgbqqG5xOLoR4EOXBz7YcxmBc0TNsRaH138Qs5k6-e8YA@mail.gmail.com>
Subject: Re: [RFC] Moving magnetometer HMC6352 into IIO subsystem
From: Jonathan Kunkee <jonathan.kunkee@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Should the HMC6352 digital compass driver be moved [...]?
>
> No - that would be a regression .. but read on

>> [...] they should almost always land in IIO land.
>
> IIO is a staging project that may never go anywhere - some of us are
> using magnetometers in product so this alone isn't an answer that works
> right now.

In my reading I failed to catch the how transient 'staging' is--I'll
keep it mind, as I'm hoping my driver will not be so transient.

>> I would be willing to work on the change as I want to submit a similar
>> driver for the HMC6343 magnetometer/accelerometer as well.
>
> It would be great if it got added into the IIO subystem *as well*, and in
> time when and if IIO goes out of staging it would then eventually replace
> the existing drivers.

This would then necessitate maintaining both chunks of code, so I think
for now I will develop my module in drivers/misc. After it has stabilized,
I can add both modules to IIO as well with this in mind.

Thanks!
--Jon Kunkee
