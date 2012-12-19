Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab2LSS2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 13:28:41 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:49978 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab2LSS2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 13:28:33 -0500
Message-ID: <50D2074D.4000101@linaro.org>
Date: Wed, 19 Dec 2012 10:28:29 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Bernd Faust <berndfaust@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] Round the calculated scale factor in set_cyc2ns_scale()
References: <1354717009-2687-1-git-send-email-berndfaust@gmail.com>
In-Reply-To: <1354717009-2687-1-git-send-email-berndfaust@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2012 06:16 AM, Bernd Faust wrote:
> During some experiments with an external clock (in a FPGA), we saw that
> the TSC clock drifted approx. 2.5ms per second.
>
> This drift was caused by the current way of calculating the scale.
> In our case cpu_khz had a value of 3292725. This resulted in a scale
> value of 310. But when doing the calculation by hand it shows that the
> actual value is 310.9886188491, so a value of 311 would be more precise.
>
> With this change the value is rounded.
>
> Signed-off-by: Bernd Faust <berndfaust@gmail.com>

Thanks for sending this in! I've queued it, but because I was slow here, 
it will have to wait for 3.9.

Sorry for the delay, and thanks again!
-john

