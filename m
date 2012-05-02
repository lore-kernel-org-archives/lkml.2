Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab2EBXKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 19:10:18 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:33539 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2EBXKQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 19:10:16 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-132.messagelabs.com!1336000203!8790597!10
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Date: Wed, 2 May 2012 18:10:10 -0500
Subject: RE: [PATCH] Extcon: fix section mismatch in extcon_gpio.c
Thread-Topic: [PATCH] Extcon: fix section mismatch in extcon_gpio.c
Thread-Index: Ac0otT89HlrJY6RNSKGmWHeBbqm/BAAA1VHQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206989522B6@AUSP01VMBX24.collaborationhost.net>
References: <201205021538.45056.hartleys@visionengravers.com>
 <20120502224510.GA19693@opensource.wolfsonmicro.com>
In-Reply-To: <20120502224510.GA19693@opensource.wolfsonmicro.com>
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

On Wednesday, May 02, 2012 3:45 PM, Mark Brown wrote:
> On Wed, May 02, 2012 at 03:38:44PM -0700, H Hartley Sweeten wrote:
>> Fix the section mismatch be renaming the struct platform_driver
>> variable.
>
> I'm pretty sure I sent a version of this patch sometime last week :/

If you have Mark's patch already, I have no problem with you using his
instead.

Regards,
Hartley

