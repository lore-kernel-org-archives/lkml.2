Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab1KVURE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:17:04 -0500
Received: from mail209.messagelabs.com ([216.82.255.3]:61959 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab1KVURC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:17:02 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-209.messagelabs.com!1321993011!16946914!13
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mika Westerberg <mika.westerberg@iki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "rmallon@gmail.com" <rmallon@gmail.com>,
        Rafal Prylowski <prylowski@metasoft.pl>
Date: Tue, 22 Nov 2011 14:16:47 -0600
Subject: RE: [PATCH 1/2] dma/ep93xx_dma: fix initialization of M2M control
 register
Thread-Topic: [PATCH 1/2] dma/ep93xx_dma: fix initialization of M2M control
 register
Thread-Index: AcypT17lZQnoBwcjQSuSFSjFyIeaLgABDduA
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3E96DA6B2@AUSP01VMBX24.collaborationhost.net>
References: <19bcd0ee953116fd71bc1c705636c5fec80608cb.1321990466.git.mika.westerberg@iki.fi>
In-Reply-To: <19bcd0ee953116fd71bc1c705636c5fec80608cb.1321990466.git.mika.westerberg@iki.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 22, 2011 12:46 PM, Mika Westerberg wrote:
> From: Rafal Prylowski <prylowski@metasoft.pl>
> 
> Setting the flags in case of IDE didn't have any effect since the control
> register is overwritten few lines below. So move these to be after the control
> register is initialized.
> 
> Signed-off-by: Rafal Prylowski <prylowski@metasoft.pl>
> Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
