Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab1H2Ibf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 04:31:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab1H2Ibb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 04:31:31 -0400
Date: Mon, 29 Aug 2011 10:29:36 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [32/35] rt2x00: fix order of entry flags modification
Message-ID: <20110829082936.GA2289@redhat.com>
References: <20110826215139.GA11498@kroah.com>
 <20110826215056.193751256@clark.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826215056.193751256@clark.kroah.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, if possible please also take in this round two other rt2x00 fixes,
I posted backports to stable ML on Thu, 25 Aug:

[PATCH 3.0.y 1/3] rt2x00: fix crash in rt2800usb_write_tx_desc
[PATCH 3.0.y 3/3] rt2x00: fix crash in rt2800usb_get_txwi

Thanks
Stanislaw 

