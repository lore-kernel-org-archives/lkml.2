Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084Ab0CPQBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 12:01:37 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.31]:60357 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759026Ab0CPQB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 12:01:29 -0400
Message-ID: <4B9FAB53.7000709@ladisch.de>
Date: Tue, 16 Mar 2010 17:01:23 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Magnus Lynch <maglyx@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
CC: "Venkatesh Pallipadi (Venki)" <venkatesh.pallipadi@intel.com>,
       Vojtech Pavlik <vojtech@suse.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hpet: factor timer allocate from open
References: <4b943f17.4902be0a.5bd5.0917@mx.google.com>
In-Reply-To: <4b943f17.4902be0a.5bd5.0917@mx.google.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Lynch wrote:
> Clemens Ladisch wrote:
>>> If so I can change that. I did add the explicit form of allocating
>>> timers to accomodate such a case hypothetically (open, allocate timer,
>>> get info).
>>
>> This wouldn't be backwards compatible.
> 
> OK, here's a version that retains HPET_INFO semantics.
> 
> Signed-off-by: Magnus Lynch <maglyx@gmail.com>

Acked-by: Clemens Ladisch <clemens@ladisch.de>
