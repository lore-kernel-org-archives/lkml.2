Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934760Ab1ETONp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:13:45 -0400
Received: from smtp105.prem.mail.sp1.yahoo.com ([98.136.44.60]:29702 "HELO
	smtp105.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932841Ab1ETONo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:13:44 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: E4KUZiAVM1mHNmtz8eGLLbDOoku9YNN9NeezpQuz9LpN2ll
 Oaj5KFAjvypYYmkoqqF5ck4giaRHVBytGsx4UABpIhDqafl3qgMj1g92iPI8
 oAXsuMT2Pw4XZ06s7R0_YVutQypL_jmlIyMEUX31QcqhoTdNFGuEa.MHKhSU
 kRnR1jey4iAaFsULO8NNotiIXP3xY7osYI09udo_03Qdd0hGzWUNDXRUM2OF
 MmkcLeSNRPUHjL5OFU5GrJGf8iQEKgBdoAvpSpRdVfQw52KgWG3.2KDLbj.2
 Xf5jkoPp1D72lhYatf89Zi5_HQQ0KgSO4ewLmimeahzdCCZRinvEHYsjGlXs
 MVdowQv_BAVzkgjj1NiCcYQrln5O4GOmifw--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4DD67706.2030603@schaufler-ca.com>
Date: Fri, 20 May 2011 07:13:26 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, David Safford <safford@watson.ibm.com>,
        Greg KH <greg@kroah.com>, Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v5 00/21] EVM
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>  <20110518172552.6d482c7a.akpm@linux-foundation.org> <1305769890.3304.90.camel@localhost.localdomain> <alpine.LRH.2.00.1105201041000.28923@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1105201041000.28923@tundra.namei.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/19/2011 5:51 PM, James Morris wrote:
> On Wed, 18 May 2011, Mimi Zohar wrote:
>
>>> Once we have a better understanding of what the feature does and why it
>>> does it and how it interfaces with the user, we can start looking at
>>> the implementation.
>> Much appreciated!
> What is the status of potential users of the feature?
>
> I recall that MeeGo were planning to use EVM, but they've since changed 
> their security plans.  Do they still plan to use it?

It's something we'll be discussing at the MeeGo conference in San Francisco
next week.


> Are any other users 
> committing to use EVM?
>
> Also -- this was raised some time back, but I can't find the discussion -- 
> what does IMA/EVM provide over disk encryption as a protection against 
> offline attacks?
>
> - James

