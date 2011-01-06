Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab1AFWUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:20:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51823 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377Ab1AFWUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:20:01 -0500
Date: Thu, 6 Jan 2011 14:09:17 -0800
From: Greg KH <gregkh@suse.de>
To: baoyb <baoyb@avit.org.cn>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: Re: Kernel Oops at tty_buffer_request_room when using pppd program
 (2.6.37-rc4)
Message-ID: <20110106220917.GL30799@suse.de>
References: <EF6DDE218DB34702B1FA84D6CD7EA771@baoyb>
 <20101208150738.GB5669@suse.de>
 <BECB6E558F0C4305830CC2A5CF2EB439@baoyb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BECB6E558F0C4305830CC2A5CF2EB439@baoyb>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 07:00:16PM +0800, baoyb wrote:
> Hi All:
> I have tested 2.6.37-rc5 and the bug still exist.
> I also tested 2.6.32.24, the oops frequency is much lower than
> 2.6.37. (Only happened 2 times in one week).

{sigh}

I really don't know what to say here.  Do you have the full backtrace of
the oops with 2.6.37?  Is the device disconnecting right before the oops
happens?

thanks,

greg k-h
