Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab0IJJDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:03:05 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:33435 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754227Ab0IJJDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:03:03 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADOQiUxXQkjH/2dsb2JhbAChQXK9PA2FMAQ
Date: Fri, 10 Sep 2010 11:03:01 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Giel van Schijndel <me@mortis.eu>
Cc: Lutz Ballaschke <vegan.grindcore@googlemail.com>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: add f71862fg support
Message-ID: <20100910090301.GS354@infomag.iguana.be>
References: <20100906132434.GA17730@kreios.titan> <20100907131837.GH6114@salidar.me.mortis.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100907131837.GH6114@salidar.me.mortis.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

> Given that the F71862 has *two* pins assignable to the WDTRST# signal,
> please document that fact, and the reason for choosing this one in the
> code.
> 
> Perhaps it might even be desirable to insert a printk there.  This to
> make the user aware of the fact that this driver might not work if the
> pin configuration of their hardware doesn't match the assumption you
> make about it in this code.

I propose to Document it in the code and add a module-parameter so that it is selectable.

Kind regards,
Wim.

