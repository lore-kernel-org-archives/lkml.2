Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786Ab2GFWyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 18:54:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41845 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab2GFWyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 18:54:04 -0400
Date: Fri, 6 Jul 2012 15:54:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: comedi: drivers: usbduxfast: changed
 "printk(KERN_ERR ..." for "pr_err(..."
Message-ID: <20120706225401.GB10471@kroah.com>
References: <1340857427-21915-1-git-send-email-sebastianbenvenuti@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340857427-21915-1-git-send-email-sebastianbenvenuti@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 01:23:47AM -0300, Sebastian Benvenuti wrote:
> changed 3 instances of printk(KERN_ERR for the prefered pr_err(
> 
> Signed-off-by: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>

Where was patch 1/2?

