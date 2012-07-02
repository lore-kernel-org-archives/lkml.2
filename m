Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211Ab2GBWq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 18:46:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48699 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933182Ab2GBWqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 18:46:51 -0400
Message-ID: <4FF224D5.5090602@gmail.com>
Date: Mon, 02 Jul 2012 17:46:45 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: balbi@ti.com
CC: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Li Yang <leoli@freescale.com>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH 5/5] usb: gadget: composite: parse dt overrides
References: <1340720833-781-1-git-send-email-aletes.xgr@gmail.com> <1340720833-781-6-git-send-email-aletes.xgr@gmail.com> <20120702073522.GE16670@arwen.pp.htv.fi>
In-Reply-To: <20120702073522.GE16670@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 02:35 AM, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Jun 26, 2012 at 11:27:13AM -0300, Alexandre Pereira da Silva wrote:
>> Grab the devicetree node properties to override VendorId, ProductId,
>> bcdDevice, Manucacturer, Product and SerialNumber
>>
>> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> 
> I need Grant's acked-by to queue this one.
> 

Grant is pretty much offline for the next 2 months, so:

Acked-by: Rob Herring <rob.herring@calxeda.com>

Rob
