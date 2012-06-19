Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab2FSFnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 01:43:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40090 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab2FSFno convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 01:43:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120619041154.GA28651@shangw>
References: <1339623535.3321.4.camel@lappy>
	<20120614032005.GC3766@dhcp-172-17-108-109.mtv.corp.google.com>
	<1339667440.3321.7.camel@lappy>
	<20120618223203.GE32733@google.com>
	<1340059850.3416.3.camel@lappy>
	<20120619041154.GA28651@shangw>
Date: Mon, 18 Jun 2012 22:43:44 -0700
X-Google-Sender-Auth: oc1ywx2lxDtE_8hLjW1XY-WBvwc
Message-ID: <CAE9FiQVitg0ODjph96LnPD6pnWSSN8QkFngEwbUX9-nT-sdy+g@mail.gmail.com>
Subject: Re: Early boot panic on machine with lots of memory
From: Yinghai Lu <yinghai@kernel.org>
To: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, hpa@linux.intel.com,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 9:11 PM, Gavin Shan <shangw@linux.vnet.ibm.com> wrote:
> :
> [    0.000000]    memblock_free: [0x0000102febc080-0x0000102febf080] memblock_free_reserved_regions+0x37/0x39
>
> Here, [0x0000102febc080-0x0000102febf080] was released to available memory block
> by function free_low_memory_core_early(). I'm not sure the release memblock might
> be taken by bootmem, but I think it's worthy to have a try of removing following
> 2 lines: memblock_free_reserved_regions() and memblock_reserve_reserved_regions()

if it was taken, should have print out about that.

Yinghai
