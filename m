Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768439Ab2KOQen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:34:43 -0500
Received: from mail132.messagelabs.com ([216.82.242.115]:40455 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768379Ab2KOQel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:34:41 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-132.messagelabs.com!1352997280!12191150!2
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.8; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Arpith Easow Alexander <arpith99@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 15 Nov 2012 10:34:27 -0600
Subject: RE: [PATCH] Staging: comedi: drivers: replaced printk with dev_dbg
Thread-Topic: [PATCH] Staging: comedi: drivers: replaced printk with dev_dbg
Thread-Index: Ac3DTi95j0ZHWNlzQtmzKB+CB4zcUQAAH1aA
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206B2644CFA@AUSP01VMBX24.collaborationhost.net>
References: <20121110070833.GA18391@gmail.com>
 <20121113195252.GA13648@kroah.com> <20121115162740.GA10360@gmail.com>
In-Reply-To: <20121115162740.GA10360@gmail.com>
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

On Thursday, November 15, 2012 9:28 AM, Arpith Easow Alexander wrote:
> On Tue, Nov 13, 2012 at 11:52:52AM -0800, Greg KH wrote:
>> So a macro called dbgcm tests a variable called dbgcm?  Gotta love c at
>> times...
>> 
>> Just delete the macro, and the variable, and call dev_dbg() directly
>> please.
>
> Ok. Done. (Attached both changes).

Arpith,

You have two patches attached to this message. Please repost them patch as 
[PATCH v2 1/2] and [PATCH v2 2/2] and include the patches inline. It makes
them easier to review and apply.

Thanks!
Hartley

