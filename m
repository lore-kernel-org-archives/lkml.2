Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab1CAUQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:16:34 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43732 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab1CAUQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:16:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VxmyRrbW+h8U3sz2gq4a1DnVOU00czE1GJMt+4YB/OzFlH0BQXDF5u3UoxwMRd26dJ
         QAYpwg/e1RjS4IWupr0E5t1R22yEVM/k0LpCvE7A3DvVmhu/eV7AEZagZOOeoX8KEyUs
         lb3nZDXY6AhF5zfUGvRe3brTt4lQORXP9BGWU=
Subject: Re: txqueuelen has wrong units; should be time
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Albert Cahalan <acahalan@gmail.com>
Cc: David Miller <davem@davemloft.net>, johnwheffner@gmail.com,
        linville@tuxdriver.com, jussi.kivilinna@mbnet.fi, swmike@swm.pp.se,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <1299010479.2930.1.camel@edumazet-laptop>
References: <20110228165501.GC2515@tuxdriver.com>
	 <AANLkTinj5szpStmA+fZ1xggdyTS+sd8Y9jXaYquDNEjs@mail.gmail.com>
	 <AANLkTinFZu5AgfhO6PoA7C1NTGSfD8HH0KXq_o-mHEJF@mail.gmail.com>
	 <20110228.201852.193726064.davem@davemloft.net>
	 <AANLkTi=eDQh9Kvr9N_dTC5Cnbcfb+DbO-6tLxkZiEp9v@mail.gmail.com>
	 <1298964381.2676.58.camel@edumazet-laptop>
	 <AANLkTimWMZHVQSHEUPuQgFXxNg85dEOesqhZE=e6x8kb@mail.gmail.com>
	 <1299010479.2930.1.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 21:16:27 +0100
Message-ID: <1299010587.2930.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 01 mars 2011 à 21:14 +0100, Eric Dumazet a écrit :
> Le mardi 01 mars 2011 à 14:37 -0500, Albert Cahalan a écrit :
> > 
> > We certainly should allow some traffic spikes. 1 to 10 ms of
> > traffic ought to do nicely. Hundreds or thousands of ms is
> > getting way beyond "spike".
> 
> OK.

Hmm, user error, hit wrong button, sorry.



