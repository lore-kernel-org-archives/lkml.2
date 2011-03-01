Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab1CAWXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 17:23:45 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:45910 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099Ab1CAWXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 17:23:43 -0500
Date: Tue, 1 Mar 2011 23:22:29 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Pratheesh Gangadhar <pratheesh@ti.com>, linux-kernel@vger.kernel.org,
        hjk@hansjkoch.de, gregkh@suse.de, sshtylyov@mvista.com, arnd@arndb.de,
        amit.chatterjee@ti.com, davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 1/1] PRUSS UIO driver support
Message-ID: <20110301222229.GE20497@local>
References: <1299014895-2022-1-git-send-email-pratheesh@ti.com>
 <1299014895-2022-2-git-send-email-pratheesh@ti.com>
 <alpine.LFD.2.00.1103012238360.2701@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103012238360.2701@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 10:45:25PM +0100, Thomas Gleixner wrote:
> 
> > +
> > +	spin_lock_init(&lock);
> 
> Sigh. DEFINE_SPINLOCK(lock); already initializes the lock.
> 
> It's not the purpose of a review to tell you what you need to change
> mechanically. Reviewers hint to a correct solution and you are
> supposed to lookup what that solution means and act accordingly. If
> you do not understand the hint or its implications please ask _before_
> sending a new patch set.

Correct. But I'm to blame here, too, since I suggested the wrong solution.
Sorry for that, Gangadhar!

Thanks,
Hans

