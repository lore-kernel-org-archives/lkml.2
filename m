Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab2FZAJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:09:44 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:47195 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab2FZAJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:09:43 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-131.messagelabs.com!1340669381!23257759!2
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Mon, 25 Jun 2012 19:09:39 -0500
Subject: RE: [PATCH 19/33] staging: comedi: cb_das16_cs: cleanup dio
 subdevice initialization
Thread-Topic: [PATCH 19/33] staging: comedi: cb_das16_cs: cleanup dio
 subdevice initialization
Thread-Index: Ac1TLsyJOf3Yz8+SQoanORiFmC5psQAAP8SA
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698E778DE@AUSP01VMBX24.collaborationhost.net>
References: <201206251700.20240.hartleys@visionengravers.com>
In-Reply-To: <201206251700.20240.hartleys@visionengravers.com>
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

On Monday, June 25, 2012 5:00 PM, H Hartley Sweeten wrote:
> The digital i/o subdevice is always initialized due to the 'if (1)'.
> Simplify the attach by removing the test.
>
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Grr... Did it again.

Sorry Greg. That should be a Cc not a Signed-off-by. Do you want
me to repost these?

Regards,
Hartley

