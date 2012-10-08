Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab2JHJvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 05:51:33 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:48087 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751001Ab2JHJva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 05:51:30 -0400
Message-ID: <1349689477.28839.4.camel@mlindner-lin.skd.de>
Subject: Re: [patch net] sky2: fix rx filter setup on link up
From: Mirko Lindner <mlindner@marvell.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 08 Oct 2012 11:44:37 +0200
In-Reply-To: <20121004074004.GA6620@minipsycho.orion>
References: <1347894617-13614-1-git-send-email-jiri@resnulli.us>
	 <20120917091214.5cd9b0f5@nehalam.linuxnetplumber.net>
	 <20120917204724.GA1749@minipsycho.orion>
	 <175CCF5F49938B4D99B2E3EF7F558EBE1B63898F0B@SC-VEXCH4.marvell.com>
	 <20121004074004.GA6620@minipsycho.orion>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 08 Oct 2012 09:44:42.0710 (UTC) FILETIME=[8AFBF760:01CDA539]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-04 at 00:40 -0700, Jiri Pirko wrote:
> Tue, Sep 18, 2012 at 02:38:52AM CEST, mlindner@marvell.com wrote:
> >>Mon, Sep 17, 2012 at 06:12:14PM CEST, shemminger@vyatta.com wrote:
> >>>On Mon, 17 Sep 2012 17:10:17 +0200
> >>>Jiri Pirko <jiri@resnulli.us> wrote:
> >>>
> >>>> In my case I have following problem. sky2_set_multicast() sets registers
> >>>> GM_MC_ADDR_H[1-4] correctly to:
> >>>> 0000 0800 0001 0410
> >>>> However, when adapter gets link and sky2_link_up() is called, the values
> >>>> are for some reason different:
> >>>> 0000 0800 0016 0410
> >>>
> >>>Rather than papering over the problem, it would be better to
> >>>trace back what is setting those registers and fix that code.
> >
> >>Yes, I did that. No code at sky2.[ch] is writing to this registers other
> >>than sky2_set_multicast() and sky2_gmac_reset() (I hooked on sky2_write*()).
> >>So I strongly believe this is a HW issue (maybe only issue of my revision
> >>"Yukon-2 EC chip revision 2")
> >
> >I would like to check the registers as soon as I'm back in my office next week and report my findings.
> >Could you also please check the hint from Stephen?
> 
> Mirko, did you have a chance to look at this?
> 


Sorry Jiri,

I was the last three weeks at a customer's office and not in our lab.
I'll check the issue this week.

Mirko

