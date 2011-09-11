Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab1IKHJO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 03:09:14 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:50117 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab1IKHJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 03:09:13 -0400
Date: Sun, 11 Sep 2011 08:09:11 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Keith Packard <keithp@keithp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.1-rc5 is the worst
Message-ID: <20110911070910.GB6361@sucs.org>
References: <CAC9WiBjoO50H5ZQEShbdZ=64ZXz6Q-OdD+VSD-YrBry3hvdJJQ@mail.gmail.com>
 <yunbousl9f5.fsf@aiko.keithp.com>
 <CAC9WiBgaaCydvzmNgxyqYnuzH-32hhexu7TNJUai1VEnowDcCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC9WiBgaaCydvzmNgxyqYnuzH-32hhexu7TNJUai1VEnowDcCQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 10, 2011 at 09:42:39PM +0200, Francis Moreau wrote:
> 
> of course I'm having hard time to reproduce now :)
> 
> Any idea how can I force the screen to sleep ?

sleep 2; xset dpms force off

-- 
Sitsofe | http://sucs.org/~sits/
