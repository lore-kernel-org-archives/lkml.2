Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab2FDEso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 00:48:44 -0400
Received: from ozlabs.org ([203.10.76.45]:56371 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912Ab2FDEsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 00:48:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alex Shi <alex.shi@intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: add a few comments of cpumask functions
In-Reply-To: <4FC38277.2030500@intel.com>
References: <1338195748-18934-1-git-send-email-alex.shi@intel.com> <4FC373D9.7040109@linux.vnet.ibm.com> <4FC38277.2030500@intel.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 04 Jun 2012 11:06:03 +0930
Message-ID: <87d35f3lks.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2012 21:49:43 +0800, Alex Shi <alex.shi@intel.com> wrote:
> On 05/28/2012 08:47 PM, Srivatsa S. Bhat wrote:
> > "Test and Set" already has a very well-defined and well-known meaning.. Not sure if the
> > comment adds any extra value..
> 
> Yes, but it is still helpful for newbie. :)

I wonder if we should just make it clear that you should see
linux/bitmap.h, as these are designed to be exactly synonymous.

Thanks,
Rusty.
