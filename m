Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab0LHPGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:06:50 -0500
Received: from cantor.suse.de ([195.135.220.2]:39438 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755614Ab0LHPGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:06:48 -0500
Date: Wed, 8 Dec 2010 07:07:38 -0800
From: Greg KH <gregkh@suse.de>
To: baoyb <baoyb@avit.org.cn>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: Re: Kernel Oops at tty_buffer_request_room when using pppd program
 (2.6.37-rc4)
Message-ID: <20101208150738.GB5669@suse.de>
References: <EF6DDE218DB34702B1FA84D6CD7EA771@baoyb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EF6DDE218DB34702B1FA84D6CD7EA771@baoyb>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 09:55:09PM +0800, baoyb wrote:
> Hi All:
> 
> We are using a USB 3G card(HUAWEI e180) and wvdial+pppd(version
> 2.4.5) program. Sometimes kernel will crash when pppd disconnect the
> link. Our cpu platform is AMCC ppc405EX and kernel version is
> 2.6.37-rc4.

Can you try 2.6.37-rc5 and see if that fixed the issue?  A number of tty
fixes went in between those two versions that should have resolved this.

thanks,

greg k-h
