Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab2APVGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 16:06:11 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:42327 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab2APVGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 16:06:09 -0500
Message-ID: <4F14913D.6090404@hp.com>
Date: Mon, 16 Jan 2012 13:06:05 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: Arjan van de Ven <arjan@linux.intel.com>,
        Darren Hart <dvhart@linux.intel.com>, Alan Cox <alan@linux.intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, paul.gortmaker@windriver.com,
        jdmason@kudzu.us, netdev@vger.kernel.org
Subject: Re: [PATCH] pch_gbe: Use a randomly generated MAC instead of failing
 probe
References: <AE90C24D6B3A694183C094C60CF0A2F6D8AF47@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8AF47@saturn3.aculab.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2012 08:20 AM, David Laight wrote:
> Since multiple interfaces on a single system are unlikely
> to be connected to the same LAN segment, it doesn't really
> matter if they use same MAC address.
>
> For a long time sun solaris systems used the same MAC
> address (based on the system id) on all their ethernet
> interfaces.

And there was a perhaps small, but certainly non-trivial stream of 
people asking how to change that because their system(s) were indeed 
multiple ports connected to the same broadcast domain.

Long since then Sun changed their defaults, and we've gotten things like 
bonding, so I think any assumption that a system with multiple ports 
will not have then connected to the same broadcast domain is brittle at 
best.

rick jones
