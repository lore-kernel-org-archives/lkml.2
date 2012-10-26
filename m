Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965222Ab2JZQMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 12:12:36 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:47025 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964981Ab2JZQMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 12:12:34 -0400
Date: Fri, 26 Oct 2012 09:13:15 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH] debugfs: add get/set for atomic types
Message-ID: <20121026161315.GA13134@kroah.com>
References: <1351266541-17268-1-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351266541-17268-1-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 10:49:01AM -0500, Seth Jennings wrote:
> debugfs currently lacks the ability to create attributes
> that set/get atomic_t values.
> 
> This patch adds support for this through a new
> debugfs_create_atomic_t() function.

Why would you want to set an atomic variable type from userspace?  What
in-kernel code needs this?

thanks,

greg k-h
