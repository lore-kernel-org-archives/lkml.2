Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab2G3Rft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:35:49 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57358 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab2G3Rfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:35:48 -0400
Message-ID: <5016C5EF.7060707@gmail.com>
Date: Mon, 30 Jul 2012 19:35:43 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: linux-kernel@vger.kernel.org, Ville Syrjala <syrjala@sci.fi>,
        GregKH <greh@kroah.com>
Subject: Re: [PATCH 1/2] onewire: w1-gpio: add ext_pullup_enable pin in platform
 data
References: <1343249670-14985-1-git-send-email-zonque@gmail.com> <20120730173232.GA20809@ioremap.net>
In-Reply-To: <20120730173232.GA20809@ioremap.net>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.07.2012 19:32, Evgeniy Polyakov wrote:
> Hi
> 
> Sorry for long delay
> 
> On Wed, Jul 25, 2012 at 10:54:29PM +0200, Daniel Mack (zonque@gmail.com) wrote:
>> In the process of porting boards to devicetree implemenation, we should
>> keep information about external circuitry where they belong - the
>> individual drivers.
>>
>> This patch adds a way to specify a GPIO to drive the (optional) external
>> pull-up logic, rather than using a function pointer for that.
> 
> I do not object against this patch, but I have rather limited knowledge
> about gpio driver.

The first patch just offers a new way to drive an optional external
pull-up and as nobody uses that feature currently, there can't be any
breakage.

And the second patch doesn't change any functional behaviour of the
driver, it simply offers a new way to instanciate it.

> Patch looks good, feel free to add my
> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

Thanks!

> 
> Greg, please pull it into your tree, if Ville does not object.
> Thank you.
> 

