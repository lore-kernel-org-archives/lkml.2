Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab2FZTSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 15:18:54 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58288 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2FZTSw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 15:18:52 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alexandre Pereira da Silva" <aletes.xgr@gmail.com>,
        "Rob Herring" <robherring2@gmail.com>
Cc: "Grant Likely" <grant.likely@secretlab.ca>,
        "Rob Landley" <rob@landley.net>, "Felipe Balbi" <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Li Yang" <leoli@freescale.com>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        "Roland Stigge" <stigge@antcom.de>
Subject: Re: [PATCH 5/5] usb: gadget: composite: parse dt overrides
References: <1340720833-781-1-git-send-email-aletes.xgr@gmail.com>
 <1340720833-781-6-git-send-email-aletes.xgr@gmail.com>
 <4FEA02B7.3030801@gmail.com>
Date: Tue, 26 Jun 2012 21:18:48 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wgiylmt83l0zgt@mpn-glaptop>
In-Reply-To: <4FEA02B7.3030801@gmail.com>
User-Agent: Opera Mail/12.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 06/26/2012 09:27 AM, Alexandre Pereira da Silva wrote:
>> Grab the devicetree node properties to override VendorId, ProductId,
>> bcdDevice, Manucacturer, Product and SerialNumber

Like before, the code looks good to me:

Acked-by: Michal Nazarewicz <mina86@mina86.com>

Not commenting on the other aspects of the business logic though.

On Tue, 26 Jun 2012 20:43:03 +0200, Rob Herring <robherring2@gmail.com> wrote:
> I'm still confused about what is the order of priority for the 2
> possible sources of these values. The way it is written, the DT value is
> a default, not an override.

They are overwritten by module parameter but they are overwriting anything that
composite gadget might be providing.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
