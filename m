Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab2DRUf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:35:57 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:65186 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab2DRUf4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:35:56 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-127.messagelabs.com!1334781350!3436228!11
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 18 Apr 2012 15:35:41 -0500
Subject: RE: [PATCH] drivers/video/ep93xx-fb.c: clean up error-handling code
Thread-Topic: [PATCH] drivers/video/ep93xx-fb.c: clean up error-handling code
Thread-Index: Ac0dmtlFyxQlByiyTZSiTQ9y6DU+lQAB2Cgw
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206987A438B@AUSP01VMBX24.collaborationhost.net>
References: <1334777828-3557-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1334777828-3557-1-git-send-email-Julia.Lawall@lip6.fr>
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

On Wednesday, April 18, 2012 12:37 PM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> There were two problems in this code: failure of the setup function should
> free locally allocated resources like other nearby failures, and the test
> if (&info->cmap) can never be false.  To generally clean things up, this
> patch reorders the error handling code at the failed label and adds labels
> so that the conditionals are not necessary.
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>

Thanks!

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

