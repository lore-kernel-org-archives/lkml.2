Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab2FOSvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:51:25 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55910 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757231Ab2FOSvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:51:23 -0400
Message-ID: <4FDB8382.8090501@linaro.org>
Date: Fri, 15 Jun 2012 11:48:34 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: missing leap second patches in stable.
References: <20120615152007.GA11793@redhat.com>
In-Reply-To: <20120615152007.GA11793@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061518-6078-0000-0000-00000C1AFD62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2012 08:20 AM, Dave Jones wrote:
> Should these be in -stable ? Looks like all the other recent changes
> in that area are present.  With the leap second just two weeks away,
> it seems like they should be.
>
> Looks like 6b43ae8a619d17c4935c3320d2ef9e92bdeed05d is in 3.4-stable,
> (haven't checked earlier -stable trees).

So the second patch has been sent out for stable review as of yesterday. 
So it should be on its way, but you're right that I forgot to CC stable 
on the first TAI offset fix.

I'll generate the patch and send it to Greg.  Thanks for the close 
review here!

thanks
-john

