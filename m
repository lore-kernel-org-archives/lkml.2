Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158Ab0KAQ1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 12:27:08 -0400
Received: from claw.goop.org ([74.207.240.146]:57656 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782Ab0KAQ1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 12:27:07 -0400
Message-ID: <4CCEE740.3080108@goop.org>
Date: Mon, 01 Nov 2010 12:13:52 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Ian Kumlien <pomac@demius.net>
CC: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: High [extra timer interrupt] count in powertop since 2.6.36
References: <alpine.LNX.2.00.1010310148450.24290@twilight.pomac.com>
In-Reply-To: <alpine.LNX.2.00.1010310148450.24290@twilight.pomac.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/30/2010 07:52 PM, Ian Kumlien wrote:
> Hi,
>
> I have been searching the list for anyone else seeing this,
> but i haven't found anything yet - Any ideas on how to debug?
>
> From powertop:
> Top causes for wakeups:
>   84.7% (1673.3)   [extra timer interrupt]
>
> Thats a little bit high in my opinion, for some reason it seems to be
> ignored since the actual number of wakeups seems to be ~367 or so.
>
> Ideas? Suggestions?

I'm not sure, but I'm seeing something similar.

    J

