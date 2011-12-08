Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab1LHNaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 08:30:19 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64246 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1LHNaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 08:30:15 -0500
Message-ID: <4EE0BBE3.60508@gmail.com>
Date: Thu, 08 Dec 2011 07:30:11 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        Dave Martin <dave.martin@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] irqdomain: protect macro variable in domain iterators
References: <1322833997-32083-1-git-send-email-nicolas.ferre@atmel.com> <1322832609-24956-1-git-send-email-nicolas.ferre@atmel.com> <20111202134458.GD2892@localhost.localdomain> <4EE08569.3070009@atmel.com>
In-Reply-To: <4EE08569.3070009@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2011 03:37 AM, Nicolas Ferre wrote:
> On 12/02/2011 02:44 PM, Dave Martin :
>> On Fri, Dec 02, 2011 at 02:30:09PM +0100, Nicolas Ferre wrote:
>>> Signed-off-by: Nicolas Ferre<nicolas.ferre@atmel.com>
>>
>> Looks OK to me:
>>
>> Acked-by: Dave Martin<dave.martin@linaro.org>
> 
> Rob,
> 
> Do you want a different implementation for this. I think it is the
> simplest way to write this macro...
> 
> If it is ok for you, it will be interesting to include this patch
> quickly so that I will be able to queue my own patches on top of it.
> (Cc: stable can be a good idea also).
> 

Yes, it's fine. The irqdomain patches need to be taken by tglx or acked
by him. I don't think this is needed for stable. The existing users are
fine and new ones aren't going to be added to stable kernels.

Rob

