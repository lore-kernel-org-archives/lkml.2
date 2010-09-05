Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab0IEMHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 08:07:08 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64344 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab0IEMHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 08:07:07 -0400
Message-ID: <4C838635.4090709@criticallink.com>
Date: Sun, 05 Sep 2010 07:59:49 -0400
From: Michael Williamson <michael.williamson@criticallink.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk, dtor@mail.ru,
        gregkh@suse.de
Subject: Re: [PATCH v1] tps65023: Allow platforms to specify DCDC_2 and DCDC_3
 value.
References: <1283624421-10326-1-git-send-email-michael.williamson@criticallink.com> <20100905085656.GE24817@opensource.wolfsonmicro.com>
In-Reply-To: <20100905085656.GE24817@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2010 04:56 AM, Mark Brown wrote:
> On Sat, Sep 04, 2010 at 02:20:21PM -0400, Michael Williamson wrote:
> 
>> This patch allows a platform to pass in the actual voltage used
>> for these DCDC supplies such that they are reported correctly in
>> sysfs.
> 
> It's doing this using the constraints rather than through platform data,
> which isn't really idiomatic.  It would be better to do this with
> platform data like the fixed voltage regulator does.
> 

All right.  I will give it another go.  Thanks for feedback.

>> Built against 2.6.36-rc3.
> 
> It doesn't really matter here but you should always submit patches
> against linux-next.

Understood. 
