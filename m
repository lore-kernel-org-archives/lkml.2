Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab1JLCbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 22:31:35 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:58504 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751222Ab1JLCbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 22:31:34 -0400
Date: Wed, 12 Oct 2011 02:31:43 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, lennart@poettering.net,
        harald@redhat.com, david@fubar.dk, greg@kroah.com,
        KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: Re: A Plumber???s Wish List for Linux
Message-ID: <20111012023143.GA17492@hallyn.com>
References: <1317943022.1095.25.camel@mop>
 <20111007111231.6e11d18e@lxorguk.ukuu.org.uk>
 <CAPXgP12nDB2NX6hZabmkUZA9n0PZadi6Yv70LNms8fz9+MnVoA@mail.gmail.com>
 <20111007113820.3b8424a8@lxorguk.ukuu.org.uk>
 <CAPXgP11K4_eVn4_emEYVzCVUsm-BXDyStk7DnDmFpMTL=404Gg@mail.gmail.com>
 <20111007152137.GE28351@carfax.org.uk>
 <20111010111813.GF17912@twin.jikos.cz>
 <20111011131428.GA13346@hallyn.com>
 <CALQRfL676ijWFeHcYCiX4Vczk4PRd2kf1aybWFNJ3a6FB1D_5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALQRfL676ijWFeHcYCiX4Vczk4PRd2kf1aybWFNJ3a6FB1D_5A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> The benefit of Kai Gai's patch was that it exported the actual names
> of the capabilities rather than have them only stored in libcap.
> 
> It is possible to use CAP_IS_SUPPORTED(cap) (in libcap-2.21) to figure
> out the maximum capability supported by the running kernel.
> 
>   https://sites.google.com/site/fullycapable/release-notes-for-libcap

I keep forgetting about that :)

thanks, Andrew.

-serge
