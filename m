Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab1JDRGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:06:07 -0400
Received: from smtp0.epfl.ch ([128.178.224.219]:51058 "HELO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932975Ab1JDRGE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:06:04 -0400
From: Philippe =?utf-8?q?R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>
Organization: EPFL - STI - LSRO1
To: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCHv5 14/19] arm: imx: Start using struct usb_otg
Date: Tue, 4 Oct 2011 19:05:58 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.40.4-5.fc15.x86_64; KDE/4.6.5; x86_64; ; )
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Chen <peter.chen@freescale.com>,
        "Lin Tony-B19295" <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
References: <1317036092-3000-1-git-send-email-heikki.krogerus@linux.intel.com> <20111003130409.GA2487@xps8300> <CAOMZO5DwDiBa_Ksow5bt02S_zMMEn4uB_hz-5KS+dyNiZA88sQ@mail.gmail.com>
In-Reply-To: <CAOMZO5DwDiBa_Ksow5bt02S_zMMEn4uB_hz-5KS+dyNiZA88sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110041905.59247.philippe.retornaz@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 3 octobre 2011 15:29:44, Fabio Estevam a écrit :
> On Mon, Oct 3, 2011 at 10:04 AM, Heikki Krogerus
> 
> <heikki.krogerus@linux.intel.com> wrote:
> > Hi Sascha,
> > 
> > On Mon, Sep 26, 2011 at 02:21:27PM +0300, Heikki Krogerus wrote:
> >> Use struct usb_otg members with OTG specific functions instead
> >> of usb_phy members.
> >> 
> >> Includes fixes from Sascha Hauer.
> >> 
> >> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> >> Acked-by: Igor Grinberg <grinberg@compulab.co.il>
> >> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> > 
> > Have you had time to check it these work?
> 
> Adding Philippe who has access to the mx31moboard-devboard and maybe
> could run a test?

Tested on mx31moboard-marxbot, works fine (ie, nothing changed).

BTW, totally unrelated, but I had to disable the sdma in order to boot 
userspace on 3.1-rc8. It seems there is data corruption on sd card access with 
the dma now.

Regards,

Philippe
