Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762028Ab2FVK2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 06:28:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53802 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762015Ab2FVK2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 06:28:09 -0400
Message-ID: <1340360943.27031.34.camel@lappy>
Subject: Re: Early boot panic on machine with lots of memory
From: Sasha Levin <levinsasha928@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, hpa@linux.intel.com,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 22 Jun 2012 12:29:03 +0200
In-Reply-To: <20120621201935.GC4642@google.com>
References: <1339623535.3321.4.camel@lappy>
	 <20120614032005.GC3766@dhcp-172-17-108-109.mtv.corp.google.com>
	 <1339667440.3321.7.camel@lappy> <20120618223203.GE32733@google.com>
	 <1340059850.3416.3.camel@lappy> <20120619041154.GA28651@shangw>
	 <20120619212059.GJ32733@google.com> <20120621201935.GC4642@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 13:19 -0700, Tejun Heo wrote:
> Hello,
> 
> Sasha, can you please apply the following patch and verify that the
> issue is gone?

That did the trick.

Thanks!

