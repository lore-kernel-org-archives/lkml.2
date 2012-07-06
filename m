Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030181Ab2GFWyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 18:54:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41845 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab2GFWyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 18:54:15 -0400
Date: Fri, 6 Jul 2012 15:54:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Staging: comedi: drivers: usbduxfast: changed
 "printk(KERN_DEBUG ..." for "pr_debug(..."
Message-ID: <20120706225411.GC10471@kroah.com>
References: <1340857700-22904-1-git-send-email-sebastianbenvenuti@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340857700-22904-1-git-send-email-sebastianbenvenuti@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 01:28:20AM -0300, Sebastian Benvenuti wrote:
> changed 41 instances of printk(KERN_DEBUG for the prefered pr_debug(
> 
> Signed-off-by: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>

Where was patches 1/3 and 2/3?

