Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab2G3KX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 06:23:59 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:37625 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab2G3KX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 06:23:56 -0400
Date: Mon, 30 Jul 2012 12:23:05 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [RFC PATCH v5 12/19] memory-hotplug: introduce new function
 arch_remove_memory()
Message-ID: <20120730102305.GB3631@osiris.boeblingen.de.ibm.com>
References: <50126B83.3050201@cn.fujitsu.com>
 <50126E2F.8010301@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50126E2F.8010301@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12073010-3548-0000-0000-000002B0543A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 06:32:15PM +0800, Wen Congyang wrote:
> We don't call __add_pages() directly in the function add_memory()
> because some other architecture related things need to be done
> before or after calling __add_pages(). So we should introduce
> a new function arch_remove_memory() to revert the things
> done in arch_add_memory().
> 
> Note: the function for s390 is not implemented(I don't know how to
> implement it for s390).

There is no hardware or firmware interface which could trigger a
hot memory remove on s390. So there is nothing that needs to be
implemented.

