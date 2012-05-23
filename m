Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850Ab2EWVwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 17:52:51 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:32779 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab2EWVwt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 17:52:49 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-209.messagelabs.com!1337809968!6481603!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Wed, 23 May 2012 16:52:47 -0500
Subject: RE: [PATCH] staging: comedi: adl_pci7296: factor out the PCI device
 code
Thread-Topic: [PATCH] staging: comedi: adl_pci7296: factor out the PCI
 device code
Thread-Index: Ac05LKmQA/1PINKsSi2UlsV7GQhINAAAYLpA
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698BACAD5@AUSP01VMBX24.collaborationhost.net>
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

I guess I should wait until the merge window closes and Greg starts
taking patches into the staging tree before continuing...

Regards,
Hartley
