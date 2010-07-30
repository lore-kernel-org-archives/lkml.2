Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab0G3WFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 18:05:19 -0400
Received: from tuxonice.net ([74.207.252.127]:37722 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab0G3WFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 18:05:17 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C534C9D.8000600@tuxonice.net>
Date: Sat, 31 Jul 2010 08:05:17 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Bojan Smojver <bojan@rexursive.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
References: <1280465201.2600.10.camel@shrek.rexursive.com> <1280486667.2608.1.camel@shrek.rexursive.com>
In-Reply-To: <1280486667.2608.1.camel@shrek.rexursive.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bojan.

On 30/07/10 20:44, Bojan Smojver wrote:
> On Fri, 2010-07-30 at 14:46 +1000, Bojan Smojver wrote:
>> This patch speeds up hibernate/thaw operations
>
> This is probably a bit simpler.

In general, it looks good. Is an order 6 allocation really necessary, 
though? I guess they'll be more reliably achieved with swsusp freeing so 
much memory beforehand but still...

Regards,

Nigel
