Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295Ab1CWU3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:29:04 -0400
Received: from kroah.org ([198.145.64.141]:39906 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933268Ab1CWU3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:29:02 -0400
Date: Wed, 23 Mar 2011 13:28:32 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Vipin Mehta <vmehta@atheros.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kalle Valo <kvalo@adurom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        devel@linuxdriverproject.org,
        Jouni Malinen <Jouni.Malinen@atheros.com>
Subject: Re: Update on Android PM enhancements - CONFIG_HAS_EARLYSUSPEND and
 friends
Message-ID: <20110323202832.GB7409@kroah.com>
References: <AANLkTik69v+gdPzwdMSyVnvHMKbWquvfCFvHLmLu-bBB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik69v+gdPzwdMSyVnvHMKbWquvfCFvHLmLu-bBB@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 01:05:47PM -0700, Luis R. Rodriguez wrote:
> Arve,
> 
> What ever happened with your series on the Android PM extensions you
> had submitted in 2009 [1] ? I'm working on ath6kl right now and I'm
> going to remove all that early suspend crap as its not upstream and I
> want to get ath6kl into upstream proper. Do you have plans for a
> replacement? Since the thread covers wake locks, have you ironed out
> what you are going to do with that as well?

Wake locks are all taken care of, see:
	http://lwn.net/Articles/416690/
for the details.

thanks,

greg k-h
