Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab2HKJjH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 05:39:07 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62356 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab2HKJjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 05:39:04 -0400
Message-ID: <50262833.2010601@gmail.com>
Date: Sat, 11 Aug 2012 11:38:59 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rabeeh Khoury <rabeeh@solid-run.com>,
        Ian Molton <ian.molton@codethink.co.uk>, Arnd Bergmann <arnd@arndb.de>,
        Maen Suleiman <maen@marvell.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 1/6] ARM: dove: unify clock setup
References: <1344255815-4457-1-git-send-email-sebastian.hesselbarth@gmail.com> <1344255815-4457-2-git-send-email-sebastian.hesselbarth@gmail.com> <20120811091255.GA31809@lunn.ch>
In-Reply-To: <20120811091255.GA31809@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2012 11:12 AM, Andrew Lunn wrote:
>> +	/* Ensure tclk is always clocked */
>> +	clk_prepare_enable(tclk);
>>   }
>
> "ticking" would be better than clocked.
>
> Since this is a root fixed clock, is it necessary to prepare_enable()
> it? I think prepare and enable become NOPs in this situation.

Hi Andrew,

yes you are right, it is useless to prepare or enable a fixed rate clk.
I cannot be gated anyway. I'll update the patch and resend soon.

Sebastian

