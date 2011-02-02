Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab1BBXfD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 18:35:03 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:47596 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab1BBXfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 18:35:00 -0500
Message-ID: <4D49EA4B.9000703@wytron.com.tw>
Date: Thu, 03 Feb 2011 07:35:39 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, linux-input@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Walter Goossens <waltergoossens@home.nl>,
        Tobias Klauser <klto@zhaw.ch>
Subject: Re: [PATCH v2] altera_ps2: Add devicetree support
References: <20110117220415.GB17963@angua.secretlab.ca> <1295848693-28472-1-git-send-email-thomas@wytron.com.tw> <20110202043121.GF29148@angua.secretlab.ca> <4D4944AA.5040900@wytron.com.tw> <20110202153959.GD20275@angua.secretlab.ca>
In-Reply-To: <20110202153959.GD20275@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.250
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2011 11:39 PM, Grant Likely wrote:
> On Wed, Feb 02, 2011 at 07:48:58PM +0800, Thomas Chou wrote:
>> On 02/02/2011 12:31 PM, Grant Likely wrote:
>>>> +static const struct of_device_id altera_ps2_match[] = {
>>>> +	{ .compatible = "altr,ps2-1.0", },
>>>
>>> I thought I had seen 'altera' instead of an abbreviation being used in
>>> a previous patch.  I don't care much whether 'altr' or 'altera' is
>>> used, but I'd like to know that there is consensus from the Altera
>>> users so that all the drivers use the same prefix.
>>>
>>
>> We had discussed on nios2-dev mailing list, and decided to use
>> 'altr' as Walter suggested that it saves space.
>
> Is altr the stock ticker symbol?  The convention is to either use the
> stock ticker in all uppercase (although the uppercase bit hasn't been
> consistently applied), or to use the full name in lowercase.

Yes, it is the stock ticker symbol. Then we shall follow the convention, 
and change it to uppercase.

- Thomas

>
> g.
>
>

