Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab1BCXEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 18:04:47 -0500
Received: from smtpq1.tb.mail.iss.as9143.net ([212.54.42.164]:58145 "EHLO
	smtpq1.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751200Ab1BCXEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 18:04:46 -0500
Message-ID: <4D4B2BC9.1030000@home.nl>
Date: Thu, 03 Feb 2011 23:27:21 +0100
From: Walter Goossens <waltergoossens@home.nl>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Thomas Chou <thomas@wytron.com.tw>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        linux-input@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v2] altera_ps2: Add devicetree support
References: <20110117220415.GB17963@angua.secretlab.ca> <1295848693-28472-1-git-send-email-thomas@wytron.com.tw> <20110202043121.GF29148@angua.secretlab.ca> <4D4944AA.5040900@wytron.com.tw> <20110202153959.GD20275@angua.secretlab.ca>
In-Reply-To: <20110202153959.GD20275@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ZiggoSMTP-MailScanner-Information: Please contact the ISP for more information
X-ZiggoSMTP-MailScanner-ID: 1Pl7e7-00042v-L4
X-ZiggoSMTP-MailScanner: Found to be clean
X-ZiggoSMTP-MailScanner-SpamCheck: geen spam, SpamAssassin (niet cached,
	score=2.672, vereist 5, ALL_TRUSTED -1.00, BAYES_50 0.80,
	HELO_LH_HOME 1.74, RDNS_DYNAMIC 0.98, TW_LN 0.08, TW_XL 0.08)
X-ZiggoSMTP-MailScanner-SpamScore: ss
X-ZiggoSMTP-MailScanner-From: waltergoossens@home.nl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/2/11 4:39 PM, Grant Likely wrote:
> On Wed, Feb 02, 2011 at 07:48:58PM +0800, Thomas Chou wrote:
>> On 02/02/2011 12:31 PM, Grant Likely wrote:
>>>> +static const struct of_device_id altera_ps2_match[] = {
>>>> +	{ .compatible = "altr,ps2-1.0", },
>>> I thought I had seen 'altera' instead of an abbreviation being used in
>>> a previous patch.  I don't care much whether 'altr' or 'altera' is
>>> used, but I'd like to know that there is consensus from the Altera
>>> users so that all the drivers use the same prefix.
>>>
>> We had discussed on nios2-dev mailing list, and decided to use
>> 'altr' as Walter suggested that it saves space.
> Is altr the stock ticker symbol?  The convention is to either use the
> stock ticker in all uppercase (although the uppercase bit hasn't been
> consistently applied), or to use the full name in lowercase.
>
> g.
>
>
Risking my limbs here by breaking in this late in the discussion... (I 
wasn't able to reply earlier) but where does it state it needs to be 
uppercase? I found a bunch of microblaze code which seems to use the 
lowercase xlnx and freescale seems happy with fsl. Unless I'm missing 
something obvious here I guess ALTR would actually be the first to use 
uppercase.
The only reference to uppercase I found in the ePAPR docs was chapter 
1.6 that talks about uppercase hex-characters as an OUI.
Not that I terribly mind either way, but I want to double-check before 
we go ahead and change all altera-related devicetree stuff to uppercase.

Greetz
Walter


