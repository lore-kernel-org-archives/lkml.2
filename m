Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab1BAUnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:43:01 -0500
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:30027 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1BAUnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:43:00 -0500
X-Loopcount0: from 10.175.216.250
From: <Douglas_Warzecha@Dell.com>
To: <linux-kernel@vger.kernel.org>, <Stuart_Hayes@Dell.com>
Date: Tue, 1 Feb 2011 14:42:53 -0600
Subject: RE: [PATCH] dcdbas: force SMI to happen when expected
Thread-Topic: [PATCH] dcdbas: force SMI to happen when expected
Thread-Index: Acu3PG98MXpHU3c3RgShh8YfRATX4wLE6T7g
Message-ID: <CC13D7E3DE58AE4096779C4F1D272C8E27D75C5DD1@AUSX7MCPS308.AMER.DELL.COM>
References: <07E32F241046DA418A0381C1225BFC011A453F262B@AUSX7MCPS301.AMER.DELL.COM>
In-Reply-To: <07E32F241046DA418A0381C1225BFC011A453F262B@AUSX7MCPS301.AMER.DELL.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2011 12:21 PM, Stuart Hayes wrote:
> The dcdbas driver can do an I/O write to cause a SMI to occur.  On some
> systems I/O writes are posted in the chipset and don't complete
> immediately.  This can result in the SMI happening at a later time.
> This can result in random failures since the SMI handler expects the
> EBX register to contain a pointer, and the handler can write to memory.
> 
> Performing an I/O read to the same address as the I/O write will force
> the I/O write to complete.  The patch is against the 2.6.37 kernel and
> has been tested.
> 
> Signed-off-by: Stuart Hayes <stuart_hayes@dell.com>

Acked-by: Doug Warzecha <douglas_warzecha@dell.com>

