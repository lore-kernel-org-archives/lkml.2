Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab0IIVQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 17:16:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39435 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab0IIVQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 17:16:35 -0400
Message-ID: <4C894E64.3050800@zytor.com>
Date: Thu, 09 Sep 2010 14:15:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: =?UTF-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
CC: Greg KH <greg@kroah.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, glommer@redhat.com,
        alan@lxorguk.ukuu.org.uk, zamsden@redhat.com, stable@kernel.org,
        mtosatti@redhat.com, gregkh@suse.de, peter@palfrader.org,
        tglx@linutronix.de, avi@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [stable] [tip:x86/urgent] x86: Add memory modify constraints
 to xchg() and cmpxchg()
References: <4C4F7277.8050306@zytor.com> <tip-113fc5a6e8c2288619ff7e8187a6f556b7e0d372@git.kernel.org> <4C5759FF.1000807@goop.org> <20100802235950.GA662@kroah.com> <20100909195301.GA18291@nomi.cz>
In-Reply-To: <20100909195301.GA18291@nomi.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The system boots and works just fine with 2.6.32.21 with the patch reverted.
> v2.6.36-rc3-185-gd56557a works fine as well, perhaps there were other fixes
> that didn't get to stable (e.g. 4532b30).
> 

I believe this needs 69309a05907546fb686b251d4ab041c26afe1e1d, which I
think is being queued up for stable.

Could you try applying 69309a05907546fb686b251d4ab041c26afe1e1d and see
if it solves your problem.

	-hpa
