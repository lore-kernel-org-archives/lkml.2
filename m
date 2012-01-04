Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab2ADWO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 17:14:59 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:54327 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757055Ab2ADWO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 17:14:58 -0500
Message-ID: <4F04DD19.1070602@xenotime.net>
Date: Wed, 04 Jan 2012 15:13:29 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] serial/documentation: fix name of DCD cpp symbol
References: <1322857211-26654-1-git-send-email-u.kleine-koenig@pengutronix.de> <20111202234248.373cfd4f@bob.linux.org.uk>
In-Reply-To: <20111202234248.373cfd4f@bob.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2011 03:42 PM, Alan Cox wrote:
> On Fri,  2 Dec 2011 21:20:11 +0100
> Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> 
>> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>> ---
>>  Documentation/serial/driver |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/Documentation/serial/driver b/Documentation/serial/driver
>> index 77ba0af..0a25a91 100644
>> --- a/Documentation/serial/driver
>> +++ b/Documentation/serial/driver
>> @@ -101,7 +101,7 @@ hardware.
>>  	Returns the current state of modem control inputs.  The state
>>  	of the outputs should not be returned, since the core keeps
>>  	track of their state.  The state information should include:
>> -		- TIOCM_DCD	state of DCD signal
>> +		- TIOCM_CAR	state of DCD signal
>>  		- TIOCM_CTS	state of CTS signal
>>  		- TIOCM_DSR	state of DSR signal
>>  		- TIOCM_RI	state of RI signal
> 
> Acked-by: Alan Cox <alan@linux.intel.com>
> 
> but please fix the Subject line to be less confusing - it sounds like
> it changes the define not the docs... 


(sorry for the delayed reply)

I thought that DCD meant Data Carrier Detect.  Is that old?  Has it changed
to just Carrier?

Greg, do you want to merge this?

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
