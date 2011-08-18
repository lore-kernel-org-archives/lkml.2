Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab1HRVD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 17:03:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:25702 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab1HRVD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 17:03:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="39802388"
Message-ID: <4E4D7E3C.8060104@linux.intel.com>
Date: Thu, 18 Aug 2011 14:03:56 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 10/11] VFS: Cache request_queue in struct block_device
References: <1312259893-4548-1-git-send-email-andi@firstfloor.org> <1312259893-4548-11-git-send-email-andi@firstfloor.org> <20110818194245.GJ15413@redhat.com>
In-Reply-To: <20110818194245.GJ15413@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Is the performance gain because of this one less dereference really
> substantial.
Yes it is measurable on a large macro benchmark.

The gain is from doing the prefetch early enough, and that needs the 
additional pointer.

-Andi

