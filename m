Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759807Ab0I0WNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 18:13:09 -0400
Received: from trinity.fluff.org ([89.16.178.74]:60594 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755048Ab0I0WNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 18:13:07 -0400
Date: Mon, 27 Sep 2010 23:12:49 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Bernhard Walle <walle@corscience.de>, khali@linux-fr.org,
        rade.bozic.ext@nsn.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: I2C: Return -ETIMEDOUT in octeon_i2c_wait() on
	timeout
Message-ID: <20100927221249.GH21564@trinity.fluff.org>
References: <1285584916-21317-1-git-send-email-walle@corscience.de> <4CA0D516.9060404@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA0D516.9060404@caviumnetworks.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 10:32:06AM -0700, David Daney wrote:
> On 09/27/2010 03:55 AM, Bernhard Walle wrote:
>> It doesn't make sense to set result to -ETIMEDOUT but return 0 (success)
>> afterwards. Since there's code in octeon_i2c_start() to handle the
>> error, it should be called.
>>
>> Signed-off-by: Bernhard Walle<walle@corscience.de>
>
> Thanks for fixing this.
>
> Acked-by: David Daney <ddaney@caviumnetworks.com>

Ok, will put into my for -rc6 branch.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

