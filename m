Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab1LLQZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 11:25:14 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:41476 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751190Ab1LLQZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 11:25:12 -0500
Message-ID: <4EE638EA.6010909@xenotime.net>
Date: Mon, 12 Dec 2011 09:24:58 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Martyn Welch <martyn.welch@ge.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Dec 6 (staging/vme)
References: <20111206154450.5e2ef2baed27993b23a55802@canb.auug.org.au> <4EDE820E.5040006@xenotime.net>
In-Reply-To: <4EDE820E.5040006@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 12:58 PM, Randy Dunlap wrote:
> On 12/05/2011 08:44 PM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20111205:
> 
> 
> When CONFIG_GPIOLIB is not enabled:
> 
> drivers/staging/vme/devices/vme_pio2.h:237:19: error: field 'gc' has incomplete type


This error is still in linux-next of 20111212.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
