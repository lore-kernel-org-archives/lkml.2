Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab2KPO6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:58:03 -0500
Received: from mail.kernel.org ([198.145.19.201]:49141 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932Ab2KPO6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:58:02 -0500
Date: Fri, 16 Nov 2012 06:58:51 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, hjchoi <hjchoi@sysbas.com>
Subject: Re: [PATCH] staging: Add SystemBase Multi-2/PCI driver
Message-ID: <20121116145851.GA20180@kroah.com>
References: <1353040771.7586.2.camel@gandalf.local.home>
 <20121116050807.GA13122@kroah.com>
 <1353071875.7586.5.camel@gandalf.local.home>
 <20121116133255.GA30683@kroah.com>
 <1353076129.7586.10.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353076129.7586.10.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 09:28:49AM -0500, Steven Rostedt wrote:
> On Fri, 2012-11-16 at 05:32 -0800, Greg Kroah-Hartman wrote:
> 
> > Redo this aginast 3.7-rc5 and we should be better off.  If you really
> > want to do this right, do this against the tty-next git tree, to catch
> > all of the recent tty changes that will be going into 3.8.
> 
> I did it against linux-next commit:

Much better, that worked, now applied.

thanks,

greg k-h
