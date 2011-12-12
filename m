Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab1LLWb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:31:58 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60384 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219Ab1LLWby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:31:54 -0500
X-Sasl-enc: /4KOTPcimjDe8pjjMeWCGZbIDOPVkqFVnr7Waibwn8G/ 1323729113
Date: Mon, 12 Dec 2011 14:20:30 -0800
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/3] DEBUGFS: Add per cpu counters
Message-ID: <20111212222030.GB2268@kroah.com>
References: <1322856167-23030-1-git-send-email-andi@firstfloor.org>
 <1322856167-23030-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322856167-23030-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 12:02:47PM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a simple way to export per cpu counters in debugfs.
> 
> This is done using a section, so that they can be declared using
> a simple macro with minimal typing.
> 
> OPEN: modules are not supported yet.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

After applying the previous patch, this one still needs "fuzz" which
makes git not happy, care to redo this one as well when you redo the 1/3
patch?

And I'm guessing that I don't need 3/3?

thanks,

greg k-h
