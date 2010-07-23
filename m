Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab0GWKuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 06:50:54 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43871 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab0GWKuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 06:50:52 -0400
Message-ID: <4C497405.9010805@canonical.com>
Date: Fri, 23 Jul 2010 18:50:45 +0800
From: Bryan Wu <bryan.wu@canonical.com>
Reply-To: bryan.wu@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: felipe.balbi@nokia.com, linux-usb@vger.kernel.org,
        kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org,
        ricardo.salveti@canonical.com
Subject: Re: [PATCH] musb: move usb_add_hcd to the core init code from gadget
 code
References: <94320.67137.qm@web180312.mail.gq1.yahoo.com>
In-Reply-To: <94320.67137.qm@web180312.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2010 05:53 PM, David Brownell wrote:
> Are you sure this doesn't break the hardware
> initialization sequencing on some chips?
>

We tested on our Beagle board C3/C4 board and will test that on Beagle XM board 
and OMAP4 board. Since I still got a Blackfin BF527 board, I will help to test.

For other silicons, I'm not sure about that.

> I distinctly call losing over a month of development
> time on this issue, because the hardware has some
> undocumented constraints in this area.  The entire
> reeason the host init is so "late" is that doing
> it earlier (at more logically sensible moments, (in
> terms of USB specs vs Mentor silicon) broke things.
>

Yeah, that's frustrated. I also spent several days here to find a solution to 
this. I saw the comments in the code about that undocumented constraints. But 
that maybe depends on different silicon.

Thanks, Dave.
-Bryan

