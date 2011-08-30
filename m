Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab1H3WAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 18:00:38 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:42802 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752152Ab1H3WAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 18:00:37 -0400
X-Sasl-enc: 3q14aHAMnL0Sj7yJ4geBY2eO+lgSJT/3wXNyKbyHKigB 1314741636
Date: Tue, 30 Aug 2011 14:53:36 -0700
From: Greg KH <greg@kroah.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Greg KH <gregkh@suse.de>, "John W. Linville" <linville@tuxdriver.com>,
        Ivo van Doorn <IvDoorn@gmail.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [32/35] rt2x00: fix order of entry flags modification
Message-ID: <20110830215336.GC23563@kroah.com>
References: <20110826215139.GA11498@kroah.com>
 <20110826215056.193751256@clark.kroah.org>
 <20110829082936.GA2289@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829082936.GA2289@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 10:29:36AM +0200, Stanislaw Gruszka wrote:
> Greg, if possible please also take in this round two other rt2x00 fixes,
> I posted backports to stable ML on Thu, 25 Aug:
> 
> [PATCH 3.0.y 1/3] rt2x00: fix crash in rt2800usb_write_tx_desc
> [PATCH 3.0.y 3/3] rt2x00: fix crash in rt2800usb_get_txwi

Now queued up.
