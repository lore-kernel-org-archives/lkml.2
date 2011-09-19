Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab1ISScU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:32:20 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:52678 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932085Ab1ISScT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:32:19 -0400
MIME-Version: 1.0
In-Reply-To: <20110919182544.GY16381@n2100.arm.linux.org.uk>
References: <1301602523-9906-1-git-send-email-omar.ramirez@ti.com>
	<CAH+eYFBSiL44CMOpgED+TAOTUH_dQMaKKu=hC3ynG0Y2nQ8ekw@mail.gmail.com>
	<CAB-zwWi1K8y8fHzy0hgcFPgSfhMrZNfoKQ9xuU00Y1sLg6ZBmw@mail.gmail.com>
	<20110919144313.GU16381@n2100.arm.linux.org.uk>
	<20110919165943.GX16381@n2100.arm.linux.org.uk>
	<CAPnjgZ1JDGt7Dzp9VrRKKApeZ9RT9oqry+UkQZwVCw1P+t9pew@mail.gmail.com>
	<20110919182544.GY16381@n2100.arm.linux.org.uk>
Date: Mon, 19 Sep 2011 13:32:14 -0500
Message-ID: <CAB-zwWhxCJSqKkt-zTYFE2j5vXKGegYrYp2z4PnDyvurvSt0Rw@mail.gmail.com>
Subject: Re: [PATCH] ARM: BUG() dies silently
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Simon Glass <sjg@chromium.org>, Rabin Vincent <rabin@rab.in>,
        lk <linux-kernel@vger.kernel.org>,
        lak <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 19, 2011 at 1:25 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> I think I'm going to have to drop the generic bug support for the time being.

In this case then my patch can targeted for 3.1 and -stable, right? I
abandoned my change because the generic bug patch was the better
solution in the long term, but if it is being delayed I can submit
mine with your blessing.

https://lkml.org/lkml/2011/3/31/490

It just forces the compiler to generate the right code through
volatile, and while at it I could fix the other similar situations
(also noted in the patch).

Omar
