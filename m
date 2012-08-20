Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab2HTNH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:07:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60375 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847Ab2HTNHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:07:51 -0400
Message-ID: <503236A1.6090809@gmail.com>
Date: Mon, 20 Aug 2012 08:07:45 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net,
        "Mark Brown (broonie@opensource.wolfsonmicro.com)" 
	<broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH RESEND v4] spi/pl022: add devicetree support
References: <1345462769-17386-1-git-send-email-aletes.xgr@gmail.com> <50323464.4070006@antcom.de>
In-Reply-To: <50323464.4070006@antcom.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 07:58 AM, Roland Stigge wrote:
> Hi all,
> 
> On 08/20/2012 01:39 PM, Alexandre Pereira da Silva wrote:
>> Add the chipselect array and cur_cs properties to pl022 main structure
>>
>> Add a wrapper function to decide if the cs should be controlled by the
>> cs_control callback or the chipselect gpio
>>
>> Populate chipselect property from cs-gpios
>>
>> Populate master->dev.of_node, so the spi bus can find child spi
>> devices and register them
>>
>> At pl022 setup, fill chip_data structure from dt nodes, if not provided
>> by platform.
>>
>> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
>> Acked-by: Roland Stigge <stigge@antcom.de>
> 
> We somehow missed 3.6 with this one. Would be nice to have it in 3.7 now
> since it's useful for mach-lpc32xx when it's available.

Mark Brown is handling SPI right now for Grant, so please send it to
him. I have some comments on the patch though.

Rob

> 
> If there are any open issues, I can assist Alexandre on this patch.
> 
> Thanks in advance,
> 
> Roland
> 
