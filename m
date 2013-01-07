Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab3AGUkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 15:40:49 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:42028 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755601Ab3AGUks convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 15:40:48 -0500
Subject: Re: [PATCH 1/5] capemgr: Beaglebone DT overlay based cape manager
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20130107203529.GI14149@atomide.com>
Date: Mon, 7 Jan 2013 22:40:38 +0200
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <93BF5C62-ADE8-4EFC-9175-C2D7E43300E3@antoniou-consulting.com>
References: <1357584666-17374-1-git-send-email-panto@antoniou-consulting.com> <1357584666-17374-2-git-send-email-panto@antoniou-consulting.com> <20130107200945.GF14149@atomide.com> <379B16EC-BFAA-4C27-8321-E7133C03368D@antoniou-consulting.com> <20130107202306.GH14149@atomide.com> <FA4D880E-833E-43D9-A399-0A5C260E83F2@antoniou-consulting.com> <20130107203529.GI14149@atomide.com>
To: Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Jan 7, 2013, at 10:35 PM, Tony Lindgren wrote:

> * Pantelis Antoniou <panto@antoniou-consulting.com> [130107 12:29]:
>> On Jan 7, 2013, at 10:23 PM, Tony Lindgren wrote:
>>> 
>>> Well how about split it to an eeprom driver, and Linux generic
>>> device loader parts?
>>> 
>> 
>> All that's left is the eeprom driver (accessor) and calls to the 
>> generic DT overlay constructs. 
>> 
>> If you caught on the previous patchset about DT overlays it should be
>> clear.
>> 
>> So it is split along those lines already.
> 
> Hmm I was thinking something like this:
> 
> drivers/base/device-loader.c
> drivers/misc/eeprom/beaglebone-cape.c
> 
> Then you may be able to just load the configuration for it
> from a .dts file and maybe no hardware specific glue is even
> needed.
> 

At the end of the line, some kind of hardware glue is going to be needed.

I just feel that drawing from a sample size of 1 (maybe 2 if I get to throw
in the beagleboard), it is a bit premature to think about making it overly
general, besides the part that are obviously part of the infrastructure 
(like the DT overlay stuff).

What I'm getting at, is that we need some user experience about this, before
going away and creating structure out of possible misconception about the uses. 

> Regards,
> 
> Tony

Regards

-- Pantelis

