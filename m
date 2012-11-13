Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab2KMTJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 14:09:39 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43312 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609Ab2KMTJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:09:37 -0500
Message-ID: <50A29A2C.3010307@linaro.org>
Date: Tue, 13 Nov 2012 11:06:20 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time/jiffies: Make clocksource_jiffies static
References: <1350552881-16356-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1350552881-16356-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111319-3534-0000-0000-00000EE882F9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 02:34 AM, Lars-Peter Clausen wrote:
> Commit f1b8274 ("clocksource: Cleanup clocksource selection") removed all
> external references to clocksource_jiffies so there is no need to have the
> symbol globally visible.
>
> Fixes the following sparse warning:
>    CHECK   kernel/time/jiffies.c kernel/time/jiffies.c:61:20: warning: symbol 'clocksource_jiffies' was not declared. Should it be static?
>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Applied. Thanks!
-john

