Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab2FKOVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:21:47 -0400
Received: from ngcobalt02.manitu.net ([217.11.48.102]:39778 "EHLO
	ngcobalt02.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab2FKOVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:21:46 -0400
X-manitu-Original-Sender-IP: 79.214.40.70
X-manitu-Original-Receiver-Name: ngcobalt02.manitu.net
Message-ID: <4FD5FEDF.6020405@grandegger.com>
Date: Mon, 11 Jun 2012 16:21:19 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Federico Vaga <federico.vaga@gmail.com>
CC: Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "rubini@gnudd.com" <rubini@gnudd.com>,
        "anilkumar@ti.com" <anilkumar@ti.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Giancarlo ASNAGHI <giancarlo.asnaghi@st.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] c_can_pci: generic module for c_can on PCI
References: <331ABD5ECB02734CA317220B2BBEABC13E9CB18A@DBDE01.ent.ti.com> <4FCE07EE.40003@pengutronix.de> <D5ECB3C7A6F99444980976A8C6D896384FA5EC4DFC@EAPEX1MAIL1.st.com> <4FC135C6.5030206@grandegger.com> <1677842.Pq7naXsvrI@harkonnen> <D5ECB3C7A6F99444980976A8C6D896384FA5EC4B37@EAPEX1MAIL1.st.com> <3650428.HarNR9HfNF@harkonnen> <20120605131337.GA15432@mail.gnudd.com> <20120605133013.GA16108@mail.gnudd.com> <20120605165008.GA21871@mail.gnudd.com> <D5ECB3C7A6F99444980976A8C6D896384FA5EC4E62@EAPEX1MAIL1.st.com> <CAH5GJ0qgQJZwO8xn-zkMA_mMhVM=uCjuCZjd8EbJr0NyE6i+tQ@mail.gmail.com>
In-Reply-To: <CAH5GJ0qgQJZwO8xn-zkMA_mMhVM=uCjuCZjd8EbJr0NyE6i+tQ@mail.gmail.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2012 03:18 PM, Federico Vaga wrote:
> How we proceed?
> I submit my c_can_pci.c as a separated module, we create a
> c_can_platform_common.c,
> or we are thinking about a generic c_can.c as plaftorm driver?

I would accept your patch with the remaining fixes especially the new
register access methods introduced by the D_CAN support patch recently.

Any further improvements to the device abstraction and a more consistent
handling of the platform data or register access should be addressed by
sub-sequent patches.

Wolfgang.


