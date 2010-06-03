Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab0FCPL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 11:11:27 -0400
Received: from mail.perches.com ([173.55.12.10]:2640 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893Ab0FCPL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 11:11:26 -0400
Subject: Re: [net-next PATCH] drivers/net/enic: Use (pr|netdev)_<level>
 macro helpers
From: Joe Perches <joe@perches.com>
To: Scott Feldman <scofeldm@cisco.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <C82CA5A9.3677A%scofeldm@cisco.com>
References: <C82CA5A9.3677A%scofeldm@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 08:11:24 -0700
Message-ID: <1275577884.1703.11.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 00:19 -0700, Scott Feldman wrote:
> I like the dev_name(dev) in there but not the "(unregister net_device)".
> Also there where a couple of lines longer than 80 chars.
> We can fix up the patch and resubmit if you like.

I'm not constrained by 80 char lines for formats.
Have at it.  Fix it up to your liking.

cheers, Joe

