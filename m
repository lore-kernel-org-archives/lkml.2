Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab0LJITE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 03:19:04 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:47589 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927Ab0LJITC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 03:19:02 -0500
Message-ID: <4D01E26F.3090802@stericsson.com>
Date: Fri, 10 Dec 2010 09:18:55 +0100
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH] MFD: ab8500-core interrupt ffs bit bug
References: <1291298809-3275-1-git-send-email-mattias.wallin@stericsson.com> <20101209121317.GE8884@sortiz-mobl>
In-Reply-To: <20101209121317.GE8884@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/09/2010 01:13 PM, Samuel Ortiz wrote:
> Hi Mattias,
> 
> On Thu, Dec 02, 2010 at 03:06:49PM +0100, Mattias Wallin wrote:
>> This patch fixes a bug in ab8500 interrupt handling
> Patch applied. This also looks like a good candidate for 2.6.37.
I agree, AB8500 interrupts gets lost without this patch so the error is bad.
Do you want me to do anything for this to happen?
> 
> Cheers,
> Samuel.
> 
