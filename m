Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab0GaFiu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 01:38:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:42790 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab0GaFis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 01:38:48 -0400
Subject: Re: [PATCH 0/8] v3 De-couple sysfs memory directories from memory
 sections
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        greg@kroah.com, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C451BF5.50304@austin.ibm.com>
References: <4C451BF5.50304@austin.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Jul 2010 15:36:24 +1000
Message-ID: <1280554584.1902.31.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-19 at 22:45 -0500, Nathan Fontenot wrote:
> This set of patches de-couples the idea that there is a single
> directory in sysfs for each memory section.  The intent of the
> patches is to reduce the number of sysfs directories created to
> resolve a boot-time performance issue.  On very large systems
> boot time are getting very long (as seen on powerpc hardware)
> due to the enormous number of sysfs directories being created.
> On a system with 1 TB of memory we create ~63,000 directories.
> For even larger systems boot times are being measured in hours.

Greg, Kame, how do we proceed with these ? I'm happy to put them in
powerpc.git with appropriate acks or will you take them ?

Cheers,
Ben.


