Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab2DSQDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 12:03:40 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:38375 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab2DSQDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:03:39 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-209.messagelabs.com!1334851407!3592266!30
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Hannu Heikkinen <hannuxx@iki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "mika.westerberg@iki.fi" <mika.westerberg@iki.fi>
Date: Thu, 19 Apr 2012 11:03:34 -0500
Subject: RE: [PATCH v2] spi/ep93xx: clean probe/remove routines
Thread-Topic: [PATCH v2] spi/ep93xx: clean probe/remove routines
Thread-Index: Ac0d+kYAkriuLivTQwuPyQXsO+/p3wAS4iXg
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206987A4555@AUSP01VMBX24.collaborationhost.net>
References: <1334818807-4473-1-git-send-email-hannuxx@iki.fi>
In-Reply-To: <1334818807-4473-1-git-send-email-hannuxx@iki.fi>
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

On Thursday, April 19, 2012 12:00 AM, Hannu Heikkinen wrote:
>
> Use devm_* functions for managing devres resources.
>
> Also use local variable irq and remove irq variable from
> struct ep93xx_spi, as it is needed only in probe routine.
>
> Acked-by: Mika Westerberg <mika.westerberg@iki.fi>
> Signed-off-by: Hannu Heikkinen <hannuxx@iki.fi>
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Oops.. My bad. My sign off should be:

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

