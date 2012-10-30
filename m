Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750Ab2J3NIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 09:08:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45947 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932497Ab2J3NIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 09:08:37 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "dgdunix@gmail.com" <dgdunix@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: RE: [PATCH 1/2] Input: matrix-keypad - remove const from pointer to
 array of gpios
Thread-Topic: [PATCH 1/2] Input: matrix-keypad - remove const from pointer
 to array of gpios
Thread-Index: AQHNrchAMf2+3xcA7E+/lSFeYtJSC5fA43CAgA+RDUA=
Date: Tue, 30 Oct 2012 13:08:25 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13EA5AD47@DBDE01.ent.ti.com>
References: <1350630373-24279-1-git-send-email-anilkumar@ti.com>
 <1350630373-24279-2-git-send-email-anilkumar@ti.com>
 <20121019230059.GB10915@core.coreip.homeip.net>
In-Reply-To: <20121019230059.GB10915@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.132.219]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2012 at 04:30:59, Dmitry Torokhov wrote:
> On Fri, Oct 19, 2012 at 12:36:12PM +0530, AnilKumar Ch wrote:
> > Remove const from pointer to array of gpios in matrix_keypad_platform_data
> > struct. This is required if we update row_gpios and col_gpios based on
> > device tree data.
> 
> Then don't. Set them up via non-const aliases instead.
> 

Changed.

Thanks
AnilKumar
