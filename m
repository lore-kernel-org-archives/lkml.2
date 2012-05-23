Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab2EWHPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 03:15:43 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64947 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab2EWHPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 03:15:41 -0400
MIME-Version: 1.0
In-Reply-To: <20120523063218.GB11860@linux-sh.org>
References: <20120509143926.27521.20342.sendpatchset@w520>
	<20120509143934.27521.46553.sendpatchset@w520>
	<20120523063218.GB11860@linux-sh.org>
Date: Wed, 23 May 2012 16:15:39 +0900
Message-ID: <CANqRtoS09YTyL5UWhtp8Tp4A4w-TkVE8E5vUW2LM-Pxjd6uMuA@mail.gmail.com>
Subject: Re: [PATCH 01/03] clockevents: Make clockevents_config() a global symbol
From: Magnus Damm <magnus.damm@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, horms@verge.net.au,
        linux-sh@vger.kernel.org, johnstul@us.ibm.com, rjw@sisk.pl,
        gregkh@linuxfoundation.org, olof@lixom.net, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 3:32 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Wed, May 09, 2012 at 11:39:34PM +0900, Magnus Damm wrote:
>> From: Magnus Damm <damm@opensource.se>
>>
>> Make clockevents_config() into a global symbol to allow it
>> to be used by compiled-in clockevent drivers. This is needed
>> by drivers that want to update the timer frequency after
>> registration time.
>>
>> Signed-off-by: Magnus Damm <damm@opensource.se>
>
> Any update on this?

Thanks, not from my side at least. I intend to resend the same series
later this week unless it gets picked up before that.

Cheers,

/ magnus
