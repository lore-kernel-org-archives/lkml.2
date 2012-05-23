Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925Ab2EWVnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 17:43:52 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:53431 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab2EWVnu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 17:43:50 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-132.messagelabs.com!1337809428!12541668!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Wed, 23 May 2012 16:43:34 -0500
Subject: RE: [PATCH] staging: comedi: adl_pci7296: factor out the PCI device
 code
Thread-Topic: [PATCH] staging: comedi: adl_pci7296: factor out the PCI
 device code
Thread-Index: Ac05LKmQA/1PINKsSi2UlsV7GQhINAAABW0A
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698BACACF@AUSP01VMBX24.collaborationhost.net>
References: <201205231428.48061.hartleys@visionengravers.com>
 <20120523214354.GQ4637@mwanda>
In-Reply-To: <20120523214354.GQ4637@mwanda>
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

On Wednesday, May 23, 2012 2:44 PM, Dan Carpenter wrote:
> Hartley, you're doing a great job with all these patches, but it's
> going to be weeks before the merge window closes.  We're going to
> end up getting confused with all the patches floating around.
>
> Do you think you could maybe put up a git tree with the current
> stuff so people know when they're stepping on each other's toes?

I would but really don't know how/were to put one.

Also, I'm still a bit of a newbie with git. I would need some help
initially to make sure I didn't screw it up. ;-)

Hartley



