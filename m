Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab0C3BB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 21:01:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:37041 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040Ab0C3BB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 21:01:58 -0400
Message-ID: <4BB14D7B.4010602@kernel.org>
Date: Tue, 30 Mar 2010 10:01:47 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Dominik Brodowski <linux@dominikbrodowski.net>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 09/17] pcmcia: update gfp/slab.h includes
References: <1269885165-18617-1-git-send-email-tj@kernel.org>	<1269885165-18617-10-git-send-email-tj@kernel.org>	<20100329193203.GA8450@comet.dominikbrodowski.net> <20100330103129.b76a70e3.sfr@canb.auug.org.au>
In-Reply-To: <20100330103129.b76a70e3.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 30 Mar 2010 01:01:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/30/2010 08:31 AM, Stephen Rothwell wrote:
> Hi Dominik,
> On Mon, 29 Mar 2010 21:32:03 +0200 Dominik Brodowski <linux@dominikbrodowski.net> wrote:
>>
>> On Tue, Mar 30, 2010 at 02:52:37AM +0900, Tejun Heo wrote:
>>> Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
>>> gfp.h or slab.h is included as necessary.
>>>
>>> Signed-off-by: Tejun Heo <tj@kernel.org>
>>> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
>>> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
>> Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>
> 
> The plan here is for you to put this in your tree now.  It is safe to do
> so and Tejun can't carry it because this does not apply to mainline. 

Yeap, something I completely forgot about when I asked Stephen to pull
from the slabh tree.  It would be great if you can apply this one and
Stephen's patches on drivers/input/misc/ad714x.c and pcf8574_keypad.c
into input tree.

Thank you.

-- 
tejun
