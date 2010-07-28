Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab0G2AQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 20:16:14 -0400
Received: from kroah.org ([198.145.64.141]:50799 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab0G2AQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 20:16:13 -0400
Date: Wed, 28 Jul 2010 16:57:55 -0700
From: Greg KH <greg@kroah.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: stable@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhltc@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [PATCH] futex: futex_find_get_task remove credentails
 check
Message-ID: <20100728235755.GB12204@kroah.com>
References: <20100708125104.GD4925@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708125104.GD4925@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 02:51:04PM +0200, Michal Hocko wrote:
> Hi stable team,
> could you consider including the following patch (Linus tree commit:
> 7a0ea09ad5352efce8fe79ed853150449903b9f5).

Now queued up.

thanks,

greg k-h
