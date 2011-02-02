Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab1BBLs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 06:48:27 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:60369 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1BBLsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 06:48:25 -0500
Message-ID: <4D4944AA.5040900@wytron.com.tw>
Date: Wed, 02 Feb 2011 19:48:58 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, linux-input@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Walter Goossens <waltergoossens@home.nl>
Subject: Re: [PATCH v2] altera_ps2: Add devicetree support
References: <20110117220415.GB17963@angua.secretlab.ca> <1295848693-28472-1-git-send-email-thomas@wytron.com.tw> <20110202043121.GF29148@angua.secretlab.ca>
In-Reply-To: <20110202043121.GF29148@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.250
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2011 12:31 PM, Grant Likely wrote:
>> +static const struct of_device_id altera_ps2_match[] = {
>> +	{ .compatible = "altr,ps2-1.0", },
>
> I thought I had seen 'altera' instead of an abbreviation being used in
> a previous patch.  I don't care much whether 'altr' or 'altera' is
> used, but I'd like to know that there is consensus from the Altera
> users so that all the drivers use the same prefix.
>

We had discussed on nios2-dev mailing list, and decided to use 'altr' as 
Walter suggested that it saves space.

About the documentation on dts binding, shall we have a single 
altera.txt to describe all Altera related binding, and opencores.txt to 
describe all OpenCores binding? Or separate file for each core in its 
driver class?

- Thomas
