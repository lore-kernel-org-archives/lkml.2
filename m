Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab2IPWdH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 18:33:07 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54687 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab2IPWdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 18:33:05 -0400
MIME-Version: 1.0
In-Reply-To: <CC51EC7B5B7F984AA566DC102237848896F57221@hkdcw-mail1.synaptics-inc.local>
References: <CC51EC7B5B7F984AA566DC102237848896F57221@hkdcw-mail1.synaptics-inc.local>
Date: Mon, 17 Sep 2012 00:33:03 +0200
Message-ID: <CACRpkdah8jqHRVRiA35H8eSugPkWuAZES_0J+OmmBr2yR07nZw@mail.gmail.com>
Subject: Re: [PATCH] Input: Add new driver into Input Subsystem for Synaptics
 DS4 touchscreen I2C devices
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Christopher Heiny <cheiny@synaptics.com>,
        Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2012 at 11:56 AM, Alexandra Chin
<alexandra.chin@tw.synaptics.com> wrote:

> Synaptics DS4 touchscreen driver implements a generic driver supporting I2C
> protocol for Synaptics Design Studio 4 (DS4) family of Touchscreen Controllers
> which include the following:
>
> - S32xX series
> - S730X series
> - S22xx series
>
> The driver supports multifinger pointing functionality and power management.
> The driver is based on the original work submitted by
> Linus Walleij <linus.walleij@stericsson.com> and
> Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>.

Naveen's driver is sitting in drivers/staging/ste_rmi4 right now because
Christopher Heiny is working on a RMI4 bus driver, and wanted to
merge that.

I am happy with this being merged for now if the plan is
to eventually replace it with Christopher's (et al) driver,
if it's not going to disturb the other driver in the end.

How are Synaptics planning to handle the transition?
(I assume you are coordinated... not always the case in
big companies, I know from experience :-)

Remember to keep Henrik Rydberg in the loop on touch
controllers.

Yours,
Linus Walleij
