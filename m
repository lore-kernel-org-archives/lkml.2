Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab2FYNxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 09:53:46 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41213 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756365Ab2FYNxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 09:53:45 -0400
Message-ID: <4FE86C1D.2020302@linux.vnet.ibm.com>
Date: Mon, 25 Jun 2012 08:48:13 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 01/10] zcache: fix preemptable memory allocation in atomic
 context
References: <4FE0392E.3090300@linux.vnet.ibm.com> <4FE36D32.3030408@linux.vnet.ibm.com> <20120623030052.GA18440@kroah.com>
In-Reply-To: <20120623030052.GA18440@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062513-5806-0000-0000-000016A08977
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2012 10:00 PM, Greg Kroah-Hartman wrote:
> On Thu, Jun 21, 2012 at 01:51:30PM -0500, Seth Jennings wrote:
>> I just noticed you sent this patchset to Andrew, but the
>> staging tree is maintained by Greg.  You're going to want to
>> send these patches to him.
>>
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> After this series is redone, right?  As it is, this submission didn't
> look ok, so I'm hoping a second round is forthcoming...

Yes. That is the cleanest way since there are dependencies
among the patches.  You could pull 04-08 and be ok, but you
might just prefer a repost.

--
Seth

