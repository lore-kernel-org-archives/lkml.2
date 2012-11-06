Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab2KFIYC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:24:02 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62244 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab2KFIYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:24:00 -0500
MIME-Version: 1.0
In-Reply-To: <1352126906-4560-3-git-send-email-larsi@wh2.tu-dresden.de>
References: <1352126906-4560-1-git-send-email-larsi@wh2.tu-dresden.de>
	<1352126906-4560-3-git-send-email-larsi@wh2.tu-dresden.de>
Date: Tue, 6 Nov 2012 09:23:58 +0100
Message-ID: <CACRpkda3w3x=uioWYZ_=CdMYBf_3Gsi6+V2im1umB6odDuSB8w@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] gpio: add viperboard gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
Cc: poeschel@lemonage.de, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linux-iio@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 3:48 PM, Lars Poeschel <larsi@wh2.tu-dresden.de> wrote:

> From: Lars Poeschel <poeschel@lemonage.de>
>
> This adds the mfd cell to use the gpio a and gpio b part
> of the Nano River Technologies viperboard.
>
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>

OK I think we can maintain this.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Please get Sam to merge this through his MFD tree.

Yours,
Linus Walleij
