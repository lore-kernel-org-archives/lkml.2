Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab1CJT1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 14:27:10 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:45951 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab1CJT1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 14:27:08 -0500
Message-id: <4D7925FB.7050205@acm.org>
Date: Thu, 10 Mar 2011 13:26:51 -0600
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14)
 Gecko/20110223 Thunderbird/3.1.8
MIME-version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        YiCheng Doe <yicheng.doe@hp.com>,
        Tom Mingarelli <thomas.mingarelli@hp.com>,
        Andy Cress <andy.cress@us.kontron.com>,
        Mika Lansirine <Mika.Lansirinne@stonesoft.com>,
        Brian De Wolf <bldewolf@csupomona.edu>,
        Jean Michel Audet <Jean-Michel.Audet@ca.Kontron.com>,
        Jozef Sudelsky <jozef.sudolsky@elbiahosting.sk>,
        Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH] ipmi: Fix IPMI errors due to timing problems
References: <1299784370-18061-1-git-send-email-minyard@acm.org>
 <20110310191704.GA24615@srcf.ucam.org>
In-reply-to: <20110310191704.GA24615@srcf.ucam.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2011 01:17 PM, Matthew Garrett wrote:
> On Thu, Mar 10, 2011 at 01:12:50PM -0600, Corey Minyard wrote:
>
>> +	smi_info->last_timeout_jiffies ?iffies;
> Something looks mangled here? Otherwise, ACK.
>
I have no idea how that happened, but it wasn't that way before I 
compiled with it.  I guess I'll resend.

-corey
