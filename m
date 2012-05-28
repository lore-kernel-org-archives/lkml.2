Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab2E1SSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 14:18:03 -0400
Received: from antcom.de ([188.40.178.216]:47847 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab2E1SSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 14:18:01 -0400
Message-ID: <4FC3C156.5040609@antcom.de>
Date: Mon, 28 May 2012 20:17:58 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de
Subject: Re: [PATCH] serial/of-serial: Add 16654 chip to compatible string
 list
References: <1338199134-23885-1-git-send-email-stigge@antcom.de> <20120528100338.GI24149@n2100.arm.linux.org.uk> <4FC35F97.2030400@antcom.de> <20120528150311.GA28290@n2100.arm.linux.org.uk> <4FC3A768.3060208@antcom.de> <20120528163151.GB28290@n2100.arm.linux.org.uk> <4FC3BA89.4060804@antcom.de> <20120528180139.GC28290@n2100.arm.linux.org.uk>
In-Reply-To: <20120528180139.GC28290@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/05/12 20:01, Russell King - ARM Linux wrote:
>> Now, introducing a new type, can I add to 8250.c's uart_config[] by
>> introducing a new type (no. 22) after PORT_XR17D15X? Unfortunately,
>> there are the "ARM specific type numbers" after current PORT_MAX_8250
>> (21), but those are not listed in 8250.c's uart_config[]. Or how am I
>> supposed to add a new type?
> 
> If it's 8250, stick it in with the group, otherwise the array will
> become stupidly large.  That's why there's a separation of the two.

Do you mean adding one element to uart_config[] and increasing
PORT_MAX_8250 (actually, the size of uart_config[]) by one? I would also
need to increase the indices of all the following "ARM specific type
numbers" by one (the second group).

Or did I get sth. wrong here?

Thanks in advance,

Roland
