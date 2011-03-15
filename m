Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab1COPon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 11:44:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58072 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab1COPol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 11:44:41 -0400
Date: Tue, 15 Mar 2011 08:44:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: linux-next: Tree for March 15 (xen/events.c)
Message-Id: <20110315084429.465cea61.randy.dunlap@oracle.com>
In-Reply-To: <20110315194543.a5d56c0c.sfr@canb.auug.org.au>
References: <20110315194543.a5d56c0c.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0207.4D7F8963.00C1,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011 19:45:43 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110314:
> 
> Dropped tree: xen


Hm, maybe this is already fixed in the dropped tree?

linux-next-20110315/drivers/xen/events.c:396: error: 'struct irq_data' has no member named 'affinity'

when CONFIG_SMP is not enabled.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
