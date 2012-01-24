Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab2AXVJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 16:09:55 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:49575 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755844Ab2AXVJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 16:09:53 -0500
Message-ID: <4F1F2BC9.1040109@xenotime.net>
Date: Tue, 24 Jan 2012 14:08:09 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: LKML <linux-kernel@vger.kernel.org>, linux-watchdog@vger.kernel.org,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH RESEND] watchdog: documentation: remove index-file
References: <1327346258-28697-1-git-send-email-w.sang@pengutronix.de> <20120124090933.GA23784@infomag.iguana.be>
In-Reply-To: <20120124090933.GA23784@infomag.iguana.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2012 01:09 AM, Wim Van Sebroeck wrote:
> Hi all,
> 
>> The 00-index file in the watchdog directory is, like many others,
>> outdated (conversion-howto is missing) and doesn't contain worthwhile
>> additional information. As it seems to be a maintenance burden without
>> much gain, simply remove it.
> 
> I would like to know what other kernel developers think about removing
> 00-INDEX files from the Documentation Directory.

Some of the 00-INDEX files add more info/value than others do.
I don't think that we are ready to remove all of them, but if one
of them isn't particularly useful, it can go away.  We don't need to
have one in every sub-directory.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
