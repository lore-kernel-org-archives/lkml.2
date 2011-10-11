Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab1JKR2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:28:31 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:28610 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab1JKR22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:28:28 -0400
Message-ID: <4E947CA6.9010703@atmel.com>
Date: Tue, 11 Oct 2011 19:28:06 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        claudio@evidence.eu.com, jesper.nilsson@axis.com,
        alan@lxorguk.ukuu.org.uk
CC: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        robherring2@gmail.com, linux-serial@vger.kernel.org
Subject: Re: [RFC PATCH] tty/serial: RS485 bindings for device tree
References: <1318353208-24422-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1318353208-24422-1-git-send-email-nicolas.ferre@atmel.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can also add this new property (support for it already in linux-next):

On 10/11/2011 07:13 PM, Nicolas Ferre :
> Generic bindings for RS485 feature included in some UARTs.
> Those bindings have to be used withing an UART device tree node.
> Documentation updated to link to the bindings definition.

[..]

> +Optional properties:
> +- linux,rs485-enabled-at-boot-time: empty property telling to enable the rs485
> +  feature at boot time. It can be disabled later with proper ioctl.

+- linux,rs485-rx-during-tx: empty property that enable the receiving of data
+  even whilst sending data.

> +- linux,rs485-rts-delay: prop-encoded-array <a b> where:

[..]

Best regards,
-- 
Nicolas Ferre
