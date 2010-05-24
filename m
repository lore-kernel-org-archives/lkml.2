Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab0EXWcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:32:45 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:35531 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226Ab0EXWco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:32:44 -0400
Date: Tue, 25 May 2010 00:32:21 +0200
From: Daniel Mack <daniel@caiaq.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Greg KH <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Regression] Commit "power_supply: Use attribute groups"
 breaks KDE battery monitor on openSUSE 11.3 M6
Message-ID: <20100524223221.GQ30801@buzzloop.caiaq.de>
References: <201005250028.24687.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005250028.24687.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 12:28:24AM +0200, Rafael J. Wysocki wrote:
> Your commit 5f487cd34f4337f9bc27ca19da72a39d1b0a0ab4 (power_supply: Use
> attribute groups) unfortunately breaks KDE 4.4's battery monitor from openSUSE
> 11.3 Milestone 6 on my Acer Ferrari One.  Apparently, the battery monitor can't
> access the sysfs battery attributes with this commit applied.

Can you still see the attributes in sysfs? What are their properties?

Thanks,
Daniel
