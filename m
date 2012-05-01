Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab2EASRD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:17:03 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:39414 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab2EASRA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:17:00 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-132.messagelabs.com!1335896167!10248363!93
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>
Date: Tue, 1 May 2012 13:16:48 -0500
Subject: linux-next: build failure after merge of drm-next tree
Thread-Topic: linux-next: build failure after merge of drm-next tree
Thread-Index: Ac0nxjdBE0rUbR8KQrqW5XT3CY647Q==
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698951E44@AUSP01VMBX24.collaborationhost.net>
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

Hello Alan,

linux-next is getting a build failure:

drivers/gpu/drm/gma500/mdfld_device.c:675:30: error: Expected } at end of initializer
drivers/gpu/drm/gma500/mdfld_device.c:675:30: error: got ;
drivers/gpu/drm/gma500/mdfld_device.c:676:9: error: Expected ; at the end of type declaration
drivers/gpu/drm/gma500/mdfld_device.c:676:9: error: got .
drivers/gpu/drm/gma500/mdfld_device.c:677:9: error: Expected ; at the end of type declaration
drivers/gpu/drm/gma500/mdfld_device.c:677:9: error: got .
  CC      drivers/gpu/drm/gma500/mdfld_device.o
drivers/gpu/drm/gma500/mdfld_device.c:675: error: expected '}' before ';' token

Introduced by commit d235e64a4367ad3ff204309490c4325b4f89b25b
cdv: continue synching up with updated reference code

Regards,
Hartley

