Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab2KTUK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:10:28 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43604 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2KTUK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:10:27 -0500
Date: Tue, 20 Nov 2012 15:10:25 -0500 (EST)
Message-Id: <20121120.151025.110295017516927341.davem@davemloft.net>
To: jon.mason@intel.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        dave.jiang@intel.com, nab@linux-iscsi.org
Subject: Re: [PATCH v6 0/2] PCI-Express Non-Transparent Bridge Support 
From: David Miller <davem@davemloft.net>
In-Reply-To: <1353119233-32752-1-git-send-email-jon.mason@intel.com>
References: <1353119233-32752-1-git-send-email-jon.mason@intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Mason <jon.mason@intel.com>
Date: Fri, 16 Nov 2012 19:27:11 -0700

> I am submitting version 6 of the PCI-Express Non-Transparent Bridge
> patches for inclusion in 3.8 via Greg KH's char-misc-next tree.  All
> outstanding issues have been addressed.
> 
> Version 6 corrects Greg KH's issues, most notably the improper usage of
> the Linux device model.
> http://thread.gmane.org/gmane.linux.kernel.pci/18599

For the networking bits:

Acked-by: David S. Miller <davem@davemloft.net>
