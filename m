Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab0GBELI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 00:11:08 -0400
Received: from thunk.org ([69.25.196.29]:33831 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab0GBELG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 00:11:06 -0400
Date: Fri, 2 Jul 2010 00:11:02 -0400
From: tytso@mit.edu
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [patch 119/149] ext4: check s_log_groups_per_flex in online
 resize code
Message-ID: <20100702041102.GJ1333@thunk.org>
Mail-Followup-To: tytso@mit.edu, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	stable-review@kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	Eric Sandeen <sandeen@redhat.com>
References: <20100701175144.GA2116@kroah.com>
 <20100701173216.846632087@clark.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701173216.846632087@clark.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 10:32:25AM -0700, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us know.

My only objection to these patches is that I don't know if they are
going to cause patch conflicts with the 50 or so patches which I sent
you for 2.6.32, which include both this patch and the next one.  When
I backported the patches I did have to adjust some of them to make
sure they would apply cleanly to the latest 2.6.32.X release.  By
cherry picking them, it could be that dropping those patches from
could cause no problems at all; or it could be a bit of a headache.

So it might be easier to drop these two and then wait for the next
2.6.32 stable release (which will hopefully be coming soon!) and just
take my whole set of patches....

					- Ted
