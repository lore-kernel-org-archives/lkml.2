Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab0ITTv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:51:27 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:58198 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753802Ab0ITTv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:51:26 -0400
Message-ID: <4C97BB33.5020806@euromail.se>
Date: Mon, 20 Sep 2010 21:51:15 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100916 Thunderbird/3.1.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
CC: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] hid: 3m: Convert to MT slots
References: <1283005748-3293-1-git-send-email-rydberg@euromail.se> <1283005748-3293-2-git-send-email-rydberg@euromail.se> <CE1C24FC-7C9A-4940-8141-391A368C59E5@enac.fr>
In-Reply-To: <CE1C24FC-7C9A-4940-8141-391A368C59E5@enac.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OxmOW-0001Xx-BB.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1OxmOW-0001Xx-BB 1357138eb2436858cf7da12e34dfcdd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2010 09:46 PM, Stéphane Chatty wrote:

> 
> Le 28 août 10 à 16:29, Henrik Rydberg a écrit :
> 
>>  #define MAX_SLOTS        60
>> -#define MAX_TRKID        59
>> +#define MAX_TRKID        USHRT_MAX
>>
> 
> Oops, I forgot this one: in the rest of the code, it seems to me that you use
> your knowledge that TRACKINGID cannot be more than 59 (you use it to map the
> tracking ID onto the slot ID). Therefore, why change TRKID to a larger value?


There are only 60 slots available, but an infinite number of tracking ids.
Nowhere is the tracking id assumed to be bounded by anything but MAX_TRKID.

Henrik
