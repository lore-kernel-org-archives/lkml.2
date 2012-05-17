Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760326Ab2EQA70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 20:59:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51925 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759974Ab2EQA7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 20:59:24 -0400
References: <1337167186-8535-1-git-send-email-peter.ujfalusi@ti.com> <20120516193546.GA15920@core.coreip.homeip.net> <CAPo=G1zf1XJcoKgCxMn3X09T0LOUG-9aw3iopqC7OPqcuc5hcQ@mail.gmail.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <CAPo=G1zf1XJcoKgCxMn3X09T0LOUG-9aw3iopqC7OPqcuc5hcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Input: twl6040-vibra: Update for device tree support
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Wed, 16 May 2012 17:59:14 -0700
To: "Ujfalusi, Peter" <peter.ujfalusi@ti.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Message-ID: <94a2ece7-00b3-4624-82d5-93b22695aa5d@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Ujfalusi, Peter" <peter.ujfalusi@ti.com> wrote:

>Hi Dmitry,
>
>On Wed, May 16, 2012 at 10:35 PM, Dmitry Torokhov
><dmitry.torokhov@gmail.com> wrote:
>> So in this case why don't you have parent parse all DT data and
>> construct instance of pdata for vibra driver to consume?
>
>If there is a need to change the parameters (add new ones for example)
>for the vibra driver in this way the change in code only need to be
>done in the vibra driver.
>If the MFD core would construct the pdata, in this case I would need
>to modify both the MFD core and vibra driver.
>

Ok, fair enough.

Thanks.


--
Dmitry
