Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab2LMELt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 23:11:49 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:31056 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab2LMELr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 23:11:47 -0500
Message-ID: <1355371365.18964.89.camel@misato.fc.hp.com>
Subject: Re: [RFC PATCH 02/11] drivers/base: Add hotplug framework code
From: Toshi Kani <toshi.kani@hp.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: rjw@sisk.pl, lenb@kernel.org, akpm@linux-foundation.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com,
        wency@cn.fujitsu.com, guohanjun@huawei.com, yinghai@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Wed, 12 Dec 2012 21:02:45 -0700
In-Reply-To: <20121212235418.GB22764@kroah.com>
References: <1355354243-18657-1-git-send-email-toshi.kani@hp.com>
	 <1355354243-18657-3-git-send-email-toshi.kani@hp.com>
	 <20121212235418.GB22764@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-12 at 15:54 -0800, Greg KH wrote:
> On Wed, Dec 12, 2012 at 04:17:14PM -0700, Toshi Kani wrote:
> > Added hotplug.c, which is the hotplug framework code.
> 
> Again, better naming please.

Yes, I will change it to be more specific, something like
"sys_hotplug.c".

Thanks,
-Toshi

