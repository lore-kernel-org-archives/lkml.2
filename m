Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab0KWRjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 12:39:14 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:21637 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab0KWRjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 12:39:12 -0500
Date: Tue, 23 Nov 2010 09:38:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Shreyas Bhatewara <sbhatewara@vmware.com>, pv-drivers@vmware.com
Subject: Re: linux-next: Tree for November 23 (vmxnet3)
Message-Id: <20101123093839.e618ec2c.randy.dunlap@oracle.com>
In-Reply-To: <20101123140609.2b6503ff.sfr@canb.auug.org.au>
References: <20101123140609.2b6503ff.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 14:06:09 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20101122:


when CONFIG_PCI_MSI is not enabled:

drivers/net/vmxnet3/vmxnet3_ethtool.c:562: error: 'struct vmxnet3_adapter' has no member named 'rss_conf'
drivers/net/vmxnet3/vmxnet3_ethtool.c:578: error: 'struct vmxnet3_adapter' has no member named 'rss_conf'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
