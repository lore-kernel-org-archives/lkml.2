Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab0ITU0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:26:19 -0400
Received: from mx3.orcon.net.nz ([219.88.242.53]:43458 "EHLO mx3.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731Ab0ITU0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:26:17 -0400
Message-ID: <4C97C366.80206@orcon.net.nz>
Date: Tue, 21 Sep 2010 08:26:14 +1200
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux alpha; en-US; rv:1.9.1.12) Gecko/20100913 Icedove/3.0.7
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Miklos Szeredi <miklos@szeredi.hu>, James.Bottomley@HansenPartnership.com,
        benh@kernel.crashing.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: memory barrier question
References: <E1OwI5H-0007LR-DC@pomaz-ex.szeredi.hu> <1284760148.30449.107.camel@pasglop> <20100917231222.GA3060@linux.vnet.ibm.com> <1284864421.30449.113.camel@pasglop> <20100919152638.GF3060@linux.vnet.ibm.com> <E1OxQIg-0005Nw-WE@pomaz-ex.szeredi.hu> <20100919215909.GG3060@linux.vnet.ibm.com> <1284944316.2957.795.camel@mulgrave.site> <20100920012915.GI3060@linux.vnet.ibm.com> <E1OxioY-0006nd-M9@pomaz-ex.szeredi.hu> <20100920182504.GD2408@linux.vnet.ibm.com>
In-Reply-To: <20100920182504.GD2408@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx3.orcon.net.nz on Tue, 21 Sep 2010 08:26:14 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Sep 21 08:26:15 2010
X-DSPAM-Confidence: 0.7794
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/09/10 06:25, Paul E. McKenney wrote:
> But do we really care about Alpha anymore?  (I can see it now... The
> Alpha portion of the kernel tree moves to staging...)

I do.

Sent from my Compaq Alpha XP1000 :-)

Cheers
Michael.
