Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab0HEFEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 01:04:43 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47691 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab0HEFEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 01:04:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 5 Aug 2010 13:59:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        Greg KH <greg@kroah.com>, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9] v4 Update the find_memory_block declaration
Message-Id: <20100805135944.97ecbaa4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C581C99.8090201@austin.ibm.com>
References: <4C581A6D.9030908@austin.ibm.com>
	<4C581C99.8090201@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Aug 2010 08:41:45 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> Update the find_memory_block declaration to to take a struct mem_section *
> so that it matches the definition.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Hmm...my mmotm-0727 has this definition in memory.h...

extern struct memory_block *find_memory_block(struct mem_section *);

What patch makes it unsigned long ?

