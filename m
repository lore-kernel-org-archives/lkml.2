Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab1CDGgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 01:36:04 -0500
Received: from sv2.nico22.de ([62.112.144.130]:34421 "EHLO sv2.nico22.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab1CDGgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 01:36:03 -0500
Date: Fri, 4 Mar 2011 07:35:58 +0100
From: Nico =?iso-8859-1?Q?Sch=FCmann?= <dev@nico22.de>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Network link detection
Message-ID: <20110304063558.GA4774@svh.nico22.de>
References: <20110303193006.GA29129@svh.nico22.de>
 <20110303140733.40307493@nehalam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303140733.40307493@nehalam>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 02:07:33PM -0800, Stephen Hemminger wrote:
> Simple answer is use netlink. That is what all real services use (NM, Quagga, ...)
> Netlink can be hard to parse, so I recommend using a wrapper library.
> 
> Simplest example is the link-event example in libmnl
>   http://www.netfilter.org/projects/libmnl/index.html

The link-event example does about what I plan to do - and it just 
works. So that pointer was just right. Thank you!

Nico
