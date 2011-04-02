Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab1DBVgv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 17:36:51 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:64747 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757141Ab1DBVgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 17:36:50 -0400
X-Greylist: delayed 983 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Apr 2011 17:36:49 EDT
Date: Sat, 2 Apr 2011 23:19:54 +0200
From: Alessandro Rubini <rubini@unipv.it>
To: linus.walleij@linaro.org
Cc: nikai@nikai.net, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: nomadik: avoid assigning u32 to bool
Message-ID: <20110402211954.GA22545@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <BANLkTikAG4diz-A6qfFx4cODvyR0c4oQ6g@mail.gmail.com>
References: <BANLkTikAG4diz-A6qfFx4cODvyR0c4oQ6g@mail.gmail.com>
  <20110401235113.083787a7@absol.kitzblitz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -       enabled = nmk_chip->enabled & bitmask;
>> +       enabled = !!(nmk_chip->enabled & bitmask);
> 
> I've learned to live this way of casting stuff into boolean,

I use (and love) !! since I learnt C. What I really dislike is the
concept of boolean that doesn't fit in the C way of thinking, in my opinion.
But I'm not going to change that.

Acked-by: Alessandro Rubini <rubini@unipv.it>

/alessandro
