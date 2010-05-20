Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab0ETL5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 07:57:31 -0400
Received: from poutre.nerim.net ([62.4.16.124]:56203 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098Ab0ETL5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 07:57:30 -0400
Date: Thu, 20 May 2010 13:57:27 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       lm-sensors@lm-sensors.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] Simple fan question
Message-ID: <20100520135727.7a0e07bd@hyperion.delvare>
In-Reply-To: <AANLkTilRvyWK-SEp2pgVAosaJ8GQUbbXsP4BkZBxGphU@mail.gmail.com>
References: <1272518506.24542.163.camel@pasglop>
	<20100429105740.6e3b7716@hyperion.delvare>
	<1272581806.24542.185.camel@pasglop>
	<AANLkTilRvyWK-SEp2pgVAosaJ8GQUbbXsP4BkZBxGphU@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010 08:59:50 -0700, Ray Lee wrote:
> On Thu, Apr 29, 2010 at 3:56 PM, Benjamin Herrenschmidt <
> benh@kernel.crashing.org> wrote:
> 
> > Now, maybe the best option is to have instead:
> >
> >        fan[1-*]_discrete_value
> >                Discrete value
> >                RW
> >
> >        fan[1-*]_supported values
> >                List of supported discrete values
> >                RO
> >
> 
> Perhaps a granularity (ie, step-size) instead of a full list of values?

A possible addition to the current API, yes. But it may not cover all
cases: the step size isn't necessarily constant.

-- 
Jean Delvare
