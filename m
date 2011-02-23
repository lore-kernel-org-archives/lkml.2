Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab1BWOnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 09:43:18 -0500
Received: from adelie.canonical.com ([91.189.90.139]:36486 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab1BWOnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 09:43:17 -0500
Message-ID: <4D651CFD.6070805@canonical.com>
Date: Wed, 23 Feb 2011 22:43:09 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ideapad: read brightness setting on brightness key	notify
References: <1298468399-3642-1-git-send-email-ike.pan@canonical.com> <20110223134748.GA6830@srcf.ucam.org> <4D651490.5070103@canonical.com> <20110223142253.GA8292@srcf.ucam.org>
In-Reply-To: <20110223142253.GA8292@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2011 10:22 PM, Matthew Garrett wrote:
> On Wed, Feb 23, 2011 at 10:07:12PM +0800, Ike Panhc wrote:
>> On 02/23/2011 09:47 PM, Matthew Garrett wrote:
>>>
>>> Which kernel versions does this hit?
>>>
>>
>> This patch is made against current checkout of Linus's tree.
> 
> The bug, not the patch :)
> 

This bug hits .37 and later. But patch is not suitable for .37.y

I will make another patch for stable kernel.
