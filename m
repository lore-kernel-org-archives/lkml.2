Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab1JKNOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 09:14:21 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:40010 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753398Ab1JKNOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 09:14:21 -0400
Date: Tue, 11 Oct 2011 13:14:28 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, lennart@poettering.net,
        harald@redhat.com, david@fubar.dk, greg@kroah.com,
        Andrew Morgan <morgan@kernel.org>, KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: Re: A Plumber???s Wish List for Linux
Message-ID: <20111011131428.GA13346@hallyn.com>
References: <1317943022.1095.25.camel@mop>
 <20111007111231.6e11d18e@lxorguk.ukuu.org.uk>
 <CAPXgP12nDB2NX6hZabmkUZA9n0PZadi6Yv70LNms8fz9+MnVoA@mail.gmail.com>
 <20111007113820.3b8424a8@lxorguk.ukuu.org.uk>
 <CAPXgP11K4_eVn4_emEYVzCVUsm-BXDyStk7DnDmFpMTL=404Gg@mail.gmail.com>
 <20111007152137.GE28351@carfax.org.uk>
 <20111010111813.GF17912@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111010111813.GF17912@twin.jikos.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Unfortunately I'd deleted the early part of this thread before noticing
the mention on lwn+lkml.org, but fwiw detection of the last supported
capability has been brought up before (with patchsets floated (By KaiGai
I'm pretty sure) which exported the list of capabilities through /sys or
/security), and I agree it's something we need.

-serge
