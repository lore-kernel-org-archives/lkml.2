Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab0CXP5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 11:57:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:57748 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756435Ab0CXP5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 11:57:49 -0400
Date: Wed, 24 Mar 2010 08:52:55 -0700
From: Greg KH <gregkh@suse.de>
To: Pavan Savoy <pavan_savoy@yahoo.co.in>
Cc: Marcel Holtmann <marcel@holtmann.org>, PavanSavoy <pavan_savoy@ti.com>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
Message-ID: <20100324155255.GB8579@suse.de>
References: <1269417860.11714.112.camel@localhost.localdomain> <359814.2971.qm@web94904.mail.in2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <359814.2971.qm@web94904.mail.in2.yahoo.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 08:24:01PM +0530, Pavan Savoy wrote:
> 4. As Alan suggested, If I make it self-contained by pushing number of
> line disciplines to a slightly larger number, then would it be OK ?

That is fine with me, as long as you continue to work on fixing the
issues in the code, and do not object to changing the user/kernel
interface over time to be one that is more sane.

thanks,

greg k-h
