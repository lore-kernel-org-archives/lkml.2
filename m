Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab1JCN3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:29:54 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59802 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab1JCN3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:29:45 -0400
MIME-Version: 1.0
In-Reply-To: <20111003130409.GA2487@xps8300>
References: <1317036092-3000-1-git-send-email-heikki.krogerus@linux.intel.com>
	<1317036092-3000-15-git-send-email-heikki.krogerus@linux.intel.com>
	<20111003130409.GA2487@xps8300>
Date: Mon, 3 Oct 2011 10:29:44 -0300
Message-ID: <CAOMZO5DwDiBa_Ksow5bt02S_zMMEn4uB_hz-5KS+dyNiZA88sQ@mail.gmail.com>
Subject: Re: [PATCHv5 14/19] arm: imx: Start using struct usb_otg
From: Fabio Estevam <festevam@gmail.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Chen <peter.chen@freescale.com>,
        Lin Tony-B19295 <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>,
        philippe.retornaz@epfl.ch
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 3, 2011 at 10:04 AM, Heikki Krogerus
<heikki.krogerus@linux.intel.com> wrote:
> Hi Sascha,
>
> On Mon, Sep 26, 2011 at 02:21:27PM +0300, Heikki Krogerus wrote:
>> Use struct usb_otg members with OTG specific functions instead
>> of usb_phy members.
>>
>> Includes fixes from Sascha Hauer.
>>
>> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>> Acked-by: Igor Grinberg <grinberg@compulab.co.il>
>> Cc: Sascha Hauer <s.hauer@pengutronix.de>
>
> Have you had time to check it these work?

Adding Philippe who has access to the mx31moboard-devboard and maybe
could run a test?

Regards,

Fabio Estevam
