Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab1LIPmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 10:42:21 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40015 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754321Ab1LIPmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 10:42:19 -0500
Date: Fri, 9 Dec 2011 10:42:18 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Aman Deep <amandeep3986@gmail.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Robert Morell <rmorell@nvidia.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andiry Xu <andiry.xu@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] USB: Adding #define in hub_configure() and hcd.c
 file
In-Reply-To: <1323326122-23479-1-git-send-email-amandeep3986@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1112091040040.1656-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Dec 2011, Aman Deep wrote:

> This patch is in succession of previous patch
> commit c8421147926fcacf53081a36438a0bed394da9f5
>         xHCI: Adding #define values used for hub descriptor
> 
> Hub descriptors characteristics #defines values are added in
> hub_configure() in place of magic numbers as asked by Alan Stern.
> And the indentation for switch and case is changed to be same.
> 
> Some #defines values are added in ch11.h for defining hub class
> protocols and used in hub.c and hcd.c in which magic values were
> used for hub class protocols.
> 
> Signed-off-by: Aman Deep <amandeep3986@gmail.com>

I like it!

If you're looking for more things to work on, consider the #defines in
ch11.h for the various port features and statuses.  Some of the newer
USB-3 entries were added in the wrong place, or even added twice!  It
would be good to get that straightened up.

Alan Stern

