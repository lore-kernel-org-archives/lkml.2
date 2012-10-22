Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab2JVEwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 00:52:25 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:53441 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228Ab2JVEwX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 00:52:23 -0400
From: Virupax SADASHIVPETIMATH <virupax.sadashivpetimath@stericsson.com>
To: "balbi@ti.com" <balbi@ti.com>
Cc: "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Rajaram REGUPATHY <ragupathy.rajaram@stericsson.com>,
        Praveena NADAHALLY <praveen.nadahally@stericsson.com>,
        Shuai WEN <shuai.wen@stericsson.com>
Date: Mon, 22 Oct 2012 06:51:39 +0200
Subject: RE: [PATCH] usb:musb: Dequeue urbs on device unplug
Thread-Topic: [PATCH] usb:musb: Dequeue urbs on device unplug
Thread-Index: Ac2q0AFqMSKRslXQQEKL6iqQwAnHjAFQJQ7Q
Message-ID: <A3217089E06965468FCEC60ADC3A8F925CBF1878ED@EXDCVYMBSTM006.EQ1STM.local>
References: <1349843763-24716-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
 <20121015121836.GN24333@arwen.pp.htv.fi>
In-Reply-To: <20121015121836.GN24333@arwen.pp.htv.fi>
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



> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Monday, October 15, 2012 5:49 PM
> To: Virupax SADASHIVPETIMATH
> Cc: balbi@ti.com; stern@rowland.harvard.edu; linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org; linus.walleij@linaro.org; Rajaram REGUPATHY;
> Praveena NADAHALLY
> Subject: Re: [PATCH] usb:musb: Dequeue urbs on device unplug
> 
> Hi,
> 
> On Wed, Oct 10, 2012 at 10:06:03AM +0530, Virupax Sadashivpetimath wrote:
> > Flush queued urbs on receiving device disconnect interrupt. This is
> > required for successful disconnect and successive enumeration of the
> > device.
> >
> > In a failure case khubd hangs on usb-storage thread for completion.
> > Seen in the below trace.
> >
> > [ 1355.764526] SysRq : Show Blocked State
> > [ 1355.768341]   task                PC stack   pid father
> > [ 1355.773620] khubd           D c06a1fbc     0   503      2 0x00000000
> > [ 1355.780151] [<c06a1fbc>] (__schedule+0x3f0/0x8ec) from [<c06a26a0>]
> > (schedule+0x58/0x70) [ 1355.788330] [<c06a26a0>] (schedule+0x58/0x70)
> > from [<c06a2af8>] (schedule_timeout+0x1d8/0x31c) [ 1355.796997]
> > [<c06a2af8>] (schedule_timeout+0x1d8/0x31c) from [<c06a1994>]
> > (wait_for_common+0xd8/0x180) [ 1355.806396] [<c06a1994>]
> > (wait_for_common+0xd8/0x180) from [<c06a1b14>]
> > (wait_for_completion+0x20/0x24) [ 1355.815887] [<c06a1b14>]
> I would like to get some Tested-bys here.

Can you please add 

Tested-by: <shuai.wen@stericsson.com>

Thanks 
Virupax S 
