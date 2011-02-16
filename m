Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab1BPTGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 14:06:52 -0500
Received: from core.signal11.us ([64.251.29.136]:56398 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab1BPTGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 14:06:50 -0500
Message-ID: <4D5C202B.5030403@signal11.us>
Date: Wed, 16 Feb 2011 14:06:19 -0500
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Lightning/1.0b1 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jkosina@suse.cz,
        ospite@studenti.unina.it, linux-input@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bgood@velocity.net
Subject: Re: [PATCH v4 1/2] HID: Documentation for hidraw
References: <1297829209-10511-1-git-send-email-alan@signal11.us>	<1297829209-10511-2-git-send-email-alan@signal11.us> <20110216071200.02ccdaa5@bike.lwn.net>
In-Reply-To: <20110216071200.02ccdaa5@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Feb 16 14:06:48 2011
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4d5c2048199477790883025
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2011 09:12 AM, Jonathan Corbet wrote:
>>   Documentation/hid/Makefile      |    8 ++
>>   Documentation/hid/hid-example.c |  167 +++++++++++++++++++++++++++++++++++++++
>>      
> I believe we're trying to get code - especially runnable code - out of the
> Documentation tree.  Should this go under samples/ or, if it's useful
> enough, under tools/?
>    

Hi Jon,

Not a problem. I'd say samples/ over tools/ for this stuff. I'll re-spin 
and re-submit.

Alan.


