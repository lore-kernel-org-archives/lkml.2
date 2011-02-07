Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab1BGQ3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 11:29:18 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:55328 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab1BGQ3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 11:29:16 -0500
Message-ID: <4D501500.3090707@oracle.com>
Date: Mon, 07 Feb 2011 07:51:28 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Documentation: log_buf_len accepts [KMG]
References: <20110206174504.GA23024@laptop> <20110206204002.2f3eab4e.randy.dunlap@oracle.com> <20110207114005.GB10388@laptop>
In-Reply-To: <20110207114005.GB10388@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0204.4D501DD6.0193:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/11 03:40, Ahmed S. Darwish wrote:
> On Sun, Feb 06, 2011 at 08:40:02PM -0800, Randy Dunlap wrote:
>>
>> Update the "log_buf_len" description to use [KMG] syntax for the
>> buffer size.
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> ---
>>
> 
> This implies an ACK for the original patch?

Sorry, I meant to do that separately, but yes, I'll merge it.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
