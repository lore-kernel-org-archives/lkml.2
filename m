Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab2FVUBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 16:01:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63403 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab2FVUBd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 16:01:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120622192919.GL4642@google.com>
References: <20120618223203.GE32733@google.com>
	<1340059850.3416.3.camel@lappy>
	<20120619041154.GA28651@shangw>
	<20120619212059.GJ32733@google.com>
	<20120619212618.GK32733@google.com>
	<CAE9FiQVECyRBie-kgBETmqxPaMx24kUt1W07qAqoGD4vNus5xQ@mail.gmail.com>
	<20120621201728.GB4642@google.com>
	<CAE9FiQXubmnKHjnqOxVeoJknJZFNuStCcW=1XC6jLE7eznkTmg@mail.gmail.com>
	<20120622185113.GK4642@google.com>
	<CAE9FiQVV+WOWywnanrP7nX-wai=aXmQS1Dcvt4PxJg5XWynC+Q@mail.gmail.com>
	<20120622192919.GL4642@google.com>
Date: Fri, 22 Jun 2012 13:01:32 -0700
X-Google-Sender-Auth: _Wv0kFeFcshU0z05w9nyBH3gs58
Message-ID: <CAE9FiQWcxEcuCjCSoAucvAOZ-6FCqRvjPoYc+JRmxdL50nyNxg@mail.gmail.com>
Subject: Re: Early boot panic on machine with lots of memory
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, hpa@linux.intel.com,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 12:29 PM, Tejun Heo <tj@kernel.org> wrote:
>
> I wish we had a single call - say, memblock_die(), or whatever - so
> that there's a clear indication that memblock usage is done, but yeah
> maybe another day.  Will review the patch itself.  BTW, can't you post
> patches inline anymore?  Attaching is better than corrupt but is still
> a bit annoying for review.

ok, will update memblock_clear patch to memblock_die...

using yhlu.kernel@gmail.com to get mail from the list and respond as
yinghai@kernel.org.

gmail web client does not allow us to insert plain text.

if using standline thunderbird, that seems can not handle thousand mail.

noticed now even Linus is attaching patch, so I assume that is ok
because there is no othe good rway.

Thanks

Yinghai
