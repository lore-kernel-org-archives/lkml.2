Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab0LMXQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 18:16:11 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:42634 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755059Ab0LMXQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 18:16:09 -0500
Message-ID: <4D06A90C.90009@euromail.se>
Date: Tue, 14 Dec 2010 00:15:24 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Takashi Iwai <tiwai@suse.de>, Chris Bagwell <chris@cnpbagwell.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: synaptics - add multitouch packet support
References: <1292280948-1933-1-git-send-email-rydberg@euromail.se> <4D06A7B1.6060609@canonical.com>
In-Reply-To: <4D06A7B1.6060609@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PSHc5-0003VN-6J.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PSHc5-0003VN-6J 57a341f7519787b7b7516f1128fd4138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 12:09 AM, Chase Douglas wrote:

> On 12/13/2010 02:55 PM, Henrik Rydberg wrote:
>> @@ -638,7 +677,7 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
>>  	__set_bit(BTN_LEFT, dev->keybit);
>>  	__set_bit(BTN_RIGHT, dev->keybit);
>>  
>> -	if (SYN_CAP_MULTIFINGER(priv->capabilities)) {
>> +	if (SYN_CAP_MULTIFINGER(priv->capabilities) | priv->multitouch) {
> 
> ^^ Although I think this is functionally correct, it is nevertheless a
> typo. Note that there's only one '|' where there should be two.


Ah, this one was removed but kept popping back in subsequent versions. Will fix,
but not resending now.

Thanks,
Henrik
