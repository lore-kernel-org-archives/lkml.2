Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab1K0Xi3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 18:38:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab1K0Xi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 18:38:28 -0500
Date: Mon, 28 Nov 2011 08:30:16 +0900
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] PM / Sleep: Unify diagnostic messages from device
 suspend/resume
Message-ID: <20111127233016.GA30818@suse.de>
References: <201111272357.26930.rjw@sisk.pl>
 <201111272359.00539.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111272359.00539.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 11:59:00PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make pm_op() and pm_noirq_op() use the same helper function for
> running callbacks, which will cause them to use the same format of
> diagnostic messages.  This also reduces the complexity and size of
> the code quite a bit.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Nice cleanup on both of these patches:
 Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
