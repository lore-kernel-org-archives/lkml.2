Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab2FUAVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 20:21:08 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:52861 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2FUAVH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 20:21:07 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-131.messagelabs.com!1340238065!19854832!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Wed, 20 Jun 2012 19:21:04 -0500
Subject: RE: [PATCH] staging: comedi: skel: use module_comedi_{pci_,}driver()
Thread-Topic: [PATCH] staging: comedi: skel: use
 module_comedi_{pci_,}driver()
Thread-Index: Ac1PO7hFL/hjfnVaRGu5Ag7IB+kUkwAB6Kcw
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698E7708B@AUSP01VMBX24.collaborationhost.net>
References: <201206201556.51336.hartleys@visionengravers.com>
 <20120620231230.GA28411@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F0020698E77071@AUSP01VMBX24.collaborationhost.net>
 <20120620232331.GA25587@kroah.com>
In-Reply-To: <20120620232331.GA25587@kroah.com>
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

On Wednesday, June 20, 2012 4:24 PM, Greg KH wrote:
> On Wed, Jun 20, 2012 at 06:16:52PM -0500, H Hartley Sweeten wrote:
>> Hmm. It was based on next-20120620 and created with git format-patch.
>> 
>> Do you have any other patches to that file in your staging tree that
>> have not reached the next tree yet?
>
> Possibly, depending on when -next was created, I did just apply a bunch
> of other patches a few hours ago.
>
>> Regardless, I have some other cleanup patches for that file. I'll
>> put them together as a series and repost it later.
>
> That would be great, thanks.

Not a problem.

Question.

Is there a way to do a 'git commit' with the diff generated using the
"patience diff" algorithm?

I have a patch that is really ugly when I do the git commit but looks
ok if I do a 'git diff --patience'.

Regards,
Hartley

