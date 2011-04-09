Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab1DIAsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 20:48:14 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:14566 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753454Ab1DIAsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 20:48:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAGurn01Ld/sX/2dsb2JhbAAMhD7VLZBAgSmDTHgEk3A
X-IronPort-AV: E=Sophos;i="4.63,327,1299474000"; 
   d="scan'208";a="105625780"
Message-ID: <4D9FACC9.7020200@teksavvy.com>
Date: Fri, 08 Apr 2011 20:48:09 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Bruce Stenning <b.stenning@indigovision.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com> <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com> <4D9CD275.9000002@teksavvy.com> <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com>
In-Reply-To: <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-04-08 08:43 AM, Bruce Stenning wrote:
> Hi Mark,
> 
>> On 11-04-06 10:57 AM, Bruce Stenning wrote:
>>> [...]
>>>
>>> The following changeset was seen as a strong candidate for addressing
>>> this problem:
>>>
>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=933cb8e5fcdebd4b666165e3f039f814d62b0e52
>>
>> That changeset is already in upstream kernels (kernel.org).
>> Does the latest kernel (2.6.38) w/ sata_mv work ?
> 
> The 2.6.38.2 kernel still exhibits the same lockups that we see with the
> 2.6.26 kernel.

Okay.  Just to help narrow it down a bit, how does 2.6.32 behave ?

Thanks.
