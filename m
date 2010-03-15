Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965793Ab0COXRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 19:17:30 -0400
Received: from thunk.org ([69.25.196.29]:51463 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937142Ab0COXR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 19:17:26 -0400
Date: Mon, 15 Mar 2010 19:17:15 -0400
From: tytso@mit.edu
To: Greg KH <greg@kroah.com>
Cc: "Jayson R. King" <dev@jaysonking.com>, LKML <linux-kernel@vger.kernel.org>,
       Mingming Cao <cmm@us.ibm.com>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       Stable team <stable@kernel.org>
Subject: Re: [stable] [00/11] fix ext4 deadlock on 2.6.27.y
Message-ID: <20100315231715.GJ4484@thunk.org>
Mail-Followup-To: tytso@mit.edu, Greg KH <greg@kroah.com>,
	"Jayson R. King" <dev@jaysonking.com>,
	LKML <linux-kernel@vger.kernel.org>, Mingming Cao <cmm@us.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, Stable team <stable@kernel.org>
References: <4B88BA1B.4050500@jaysonking.com>
 <20100228031635.GC1278@suse.de>
 <20100315200929.GA20466@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100315200929.GA20466@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 01:09:30PM -0700, Greg KH wrote:
> 
> As no one has responded, I'm dropping these from my email queue.  If you
> get an answer, please feel free to resend them.

Sorry, I've been crazy busy.  I'm currently testing Jayson's
backports, after having eyeballed them.  I'll resend them to you once
they finish the test cycle.

					- Ted
