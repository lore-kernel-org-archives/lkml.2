Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1A3TFj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 14:05:39 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:38338 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753770Ab1A3TFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 14:05:38 -0500
Message-ID: <4D45B6DC.9000603@metafoo.de>
Date: Sun, 30 Jan 2011 20:07:08 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: David Brownell <david-b@pacbell.net>, Eric Miao <eric.y.miao@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: Make gpio_{request,free}_array gpio array parameter
 const
References: <1296314481-28028-1-git-send-email-lars@metafoo.de> <20110130184914.GB12801@pengutronix.de>
In-Reply-To: <20110130184914.GB12801@pengutronix.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2011 07:49 PM, Wolfram Sang wrote:
> On Sat, Jan 29, 2011 at 04:21:21PM +0100, Lars-Peter Clausen wrote:
>> gpio_{request,free}_array should not (and do not) modify the passed gpio array,
>> so make the parameter const.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> Looks good to me. What about the users of these calls (luckily there don't seem
> to be many)?
> 
> Kind regards,
> 
>    Wolfram
> 

Hi

Well, they could, but don't have to, make their gpio array const now, if it is not
otherwise modified. But I guess that is something for a follow-up patch.

- Lars
