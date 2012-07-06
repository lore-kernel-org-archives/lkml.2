Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395Ab2GFWyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 18:54:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41845 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605Ab2GFWyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 18:54:31 -0400
Date: Fri, 6 Jul 2012 15:54:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Staging: comedi: drivers: usbduxfast: fixed several
 syntax issues
Message-ID: <20120706225427.GD10471@kroah.com>
References: <1340858829-26296-1-git-send-email-sebastianbenvenuti@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340858829-26296-1-git-send-email-sebastianbenvenuti@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 01:47:09AM -0300, Sebastian Benvenuti wrote:
> Fixed +40 "quoted string split across lines" issues
> plus some lines that were over 80 chars
> and a "pr_info(" function replaced "printk(KERN_INFO"
> 
> Signed-off-by: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>

Where was patches 1/4, 2/4, and 3/4?


