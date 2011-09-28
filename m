Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab1I1Nm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:42:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:47166 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab1I1NmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:42:25 -0400
Message-ID: <4E83243A.7060408@windriver.com>
Date: Wed, 28 Sep 2011 09:42:18 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the moduleh tree
References: <20110928184150.0fcf097b7f9128f8639059f3@canb.auug.org.au>
In-Reply-To: <20110928184150.0fcf097b7f9128f8639059f3@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-09-28 04:41 AM, Stephen Rothwell wrote:
> Hi Paul,
> 
> After merging the moduleh tree, today's linux-next build (x86_64
> allmodconfig) went on producing more failures (beyond those reported
> earlier).  I have used the version of the moduleh tree from next-20110927
> for today and will see if I have more stamina tomorrow.

I will grab a copy of today's next and pick up where you left off, plowing
into the new additions in next that are implicitly using module.h

Thanks again for doing more than I could have asked.
Paul.

> 
