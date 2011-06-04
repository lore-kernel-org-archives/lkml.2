Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab1FDMuc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 08:50:32 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:49423 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab1FDMub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 08:50:31 -0400
Subject: Re: Mysterious CFQ crash and RCU
From: Paul Bolle <pebolle@tiscali.nl>
To: paulmck@linux.vnet.ibm.com
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Date: Sat, 04 Jun 2011 14:50:17 +0200
In-Reply-To: <20110603050724.GB2304@linux.vnet.ibm.com>
References: <20110519222404.GG12600@redhat.com>
	 <20110521210013.GJ2271@linux.vnet.ibm.com>
	 <20110523152141.GB4019@redhat.com>
	 <20110523153848.GC2310@linux.vnet.ibm.com>
	 <1306401337.27271.3.camel@t41.thuisdomein>
	 <20110603050724.GB2304@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1307191830.23387.24.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-02 at 22:07 -0700, Paul E. McKenney wrote:
> And please accept my apologies for being so slow to get to it.

Thanks, but it was just a week (ie, quite a quick response by my
standards).

> Looks healthy to me...

How should I understand that? Something like: "As far as this hlist is
used with RCU everything seems OK. Perhaps something is messing with the
entries of this hlist outside of RCU. Perhaps additional locking is
needed."


Paul Bolle

