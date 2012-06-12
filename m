Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab2FLAtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 20:49:49 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:35689 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab2FLAts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 20:49:48 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-160.messagelabs.com!1339462187!9202984!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>
Date: Mon, 11 Jun 2012 19:49:46 -0500
Subject: RE: [PATCH] staging: comedi: cleanup alloc_subdevices
Thread-Topic: [PATCH] staging: comedi: cleanup alloc_subdevices
Thread-Index: Ac1INIUP3Vna00qrR1Oy791LGC8iHgAAB6IQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698DBC4B9@AUSP01VMBX24.collaborationhost.net>
References: <201206071508.15674.hartleys@visionengravers.com>
 <20120611235657.GA26721@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F0020698DBC4A9@AUSP01VMBX24.collaborationhost.net>
 <20120612004421.GA30997@kroah.com>
In-Reply-To: <20120612004421.GA30997@kroah.com>
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

On Monday, June 11, 2012 5:44 PM, Greg KH wrote:
> On Mon, Jun 11, 2012 at 07:07:41PM -0500, H Hartley Sweeten wrote:
>> 2, 3, and 4 probably go together. They all deal with the 'num_subdevices'
>> 
>> 1 can be a separate patch as long as I don't do the rename.
>> 
>> 5, 6, and 7 could all go together with the final rename of the function.
>> 
>> Does that sound ok?
>
> No, why not just break it up into 7 different patches?  You are doing
> different things, which would you rather review for correctness, 7
> simple, tiny patches, or some that do multiple things at the same time
> that are bigger?

Ok. I just posted the first one. It's still pretty big since it hits every
comedi driver file.

Please ignore the first post. I fat-fingered the prototype in the header.
v2 is correct.

Also, I have never done local commits to my Linux-next tree so I'm not
sure how to proceed with the incremental patches. If it's ok with you
I'll just wait for each patch to go into staging.

Regards,
Hartley

