Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab1C3KSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 06:18:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64838 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab1C3KSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 06:18:23 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=1sY0x9-OVrgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=r2cgy09oWaFgM0G3NbIA:9 a=sgGpne0BvMIx57E-3sJcMlPmYyIA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] netfilter: Fix build failure when ipv6 but xt_tproxy
 is built in
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, hidden@balabit.hu, akpm@linux-foundation.org,
        netfilter-devel@vger.kernel.org, kaber@trash.net,
        netdev@vger.kernel.org
In-Reply-To: <20110329.223536.245392030.davem@davemloft.net>
References: <1301451199.14261.327.camel@gandalf.stny.rr.com>
	 <20110329.223536.245392030.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 30 Mar 2011 06:18:20 -0400
Message-ID: <1301480300.14261.332.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 22:35 -0700, David Miller wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Tue, 29 Mar 2011 22:13:19 -0400
> 
> > While running ktest.pl doing ranconfigs, the following build error
> > occurred:
> 
> Is sending netfilter patches to the explicitly listed maintainer in
> MAINTAINERS too much to ask Stephen? :-/
> 
> CC:'d
> 

Sorry David, I just did a git blame and Cc'd the ones that did the
original change. I'll do better next time.

-- Steve


