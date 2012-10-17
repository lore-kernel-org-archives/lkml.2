Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2JQGgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:36:08 -0400
Received: from ngcobalt02.manitu.net ([217.11.48.102]:33058 "EHLO
	ngcobalt02.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab2JQGgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:36:07 -0400
X-manitu-Original-Sender-IP: 88.217.78.156
X-manitu-Original-Receiver-Name: ngcobalt02.manitu.net
Message-ID: <507E51C8.4090300@grandegger.com>
Date: Wed, 17 Oct 2012 08:35:52 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Muhammad Ghias <mghias@connecttech.com>
CC: "'Marc Kleine-Budde'" <mkl@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CAN: sja1000: Add support for Connect Tech Inc's Canpro/104-Plus
 Opto CAN board
References: <02ac01cdabe1$b5403e10$1fc0ba30$@connecttech.com>
In-Reply-To: <02ac01cdabe1$b5403e10$1fc0ba30$@connecttech.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 11:03 PM, Muhammad Ghias wrote:
> Patch adds support for CANpro/104-Plus Opto CAN board. Board uses PLX9030
> bridge and two NXP SJA1000 CAN controllers. Patch is generated and tested
> with kernel 3.6.1.
> 
> If you have any questions or any feedback please let me know.
> 
> Thanks,

The above two lines should go ...

> Signed-off-by: Muhammad Ghias <mghias@connecttech.com>
> ---

... here (out of the commit message).

Apart from that the patch looks good. You can add my

Acked-by: Wolfgang Grandegger <wg@grandegger.com>

Thanks for your contribution.

Wolfgang.

