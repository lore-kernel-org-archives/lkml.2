Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761274Ab2EKXzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 19:55:15 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:57965 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759610Ab2EKXzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 19:55:12 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-160.messagelabs.com!1336780511!6153510!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>
Date: Fri, 11 May 2012 18:55:10 -0500
Subject: RE: [PATCH] gpiolib: quiet gpiochip_add boot message noise
Thread-Topic: [PATCH] gpiolib: quiet gpiochip_add boot message noise
Thread-Index: Ac0v0VtnazjolcDMTMe7MpkMy4swbQAAAq0Q
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698A17FF0@AUSP01VMBX24.collaborationhost.net>
References: <201204131738.34500.hartleys@visionengravers.com>
 <20120511235403.E7FED3E0791@localhost>
In-Reply-To: <20120511235403.E7FED3E0791@localhost>
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

On Friday, May 11, 2012 4:54 PM, Grant Likely wrote:
> On Fri, 13 Apr 2012 17:38:34 -0700, H Hartley Sweeten <hartleys@visionengravers.com> wrote:
>> The pr_info message in gpiochip_add gets displayed for every
>> gpiochip registered. When first bringing up a system this
>> information could be helpful but for normal use it's just a
>> bunch of noise. Change the message to a pr_debug.
>> 
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Linus Walleij <linus.walleij@stericsson.com>
>
> No s-o-b?

DOH! I will repost it shortly.

Regards,
Hartley
