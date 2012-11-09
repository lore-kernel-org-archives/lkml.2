Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab2KIWGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 17:06:25 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50311 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab2KIWGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 17:06:24 -0500
Message-ID: <509D7E5E.4050301@wwwdotorg.org>
Date: Fri, 09 Nov 2012 15:06:22 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: tegra: harmony: Add ADT7641 temperature sensor
References: <1352498323-31845-1-git-send-email-thierry.reding@avionic-design.de> <20121109220330.GA31801@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121109220330.GA31801@avionic-0098.mockup.avionic-design.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 03:03 PM, Thierry Reding wrote:
> On Fri, Nov 09, 2012 at 10:58:43PM +0100, Thierry Reding wrote:
>> The Harmony board has an Analog Devices ADT7461 temperature
>> sensor connected to the DVC bus. It can be used to monitor the
>> ambient (local) and on-die (remote) temperatures.
>> 
>> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> 
> I forgot to add you Tested-by on this patch. Can you add it when
> you apply or do you want me to resend?

Thanks, applied to Tegra's for-3.8/dt branch, with my Tested-by added.


