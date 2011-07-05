Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab1GECe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 22:34:28 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:52658 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752165Ab1GECe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 22:34:27 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19E+ipWhB5EmmmY3cc52i0A0SrWM4wOQ96d/xbQvo
	IrJzjb2UvNh4zY
Subject: Re: About sched_mc_power_savings
From: Mike Galbraith <efault@gmx.de>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1275302769.22157.1309813101668.JavaMail.mail@webmail11>
References: <1275302769.22157.1309813101668.JavaMail.mail@webmail11>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jul 2011 04:34:23 +0200
Message-ID: <1309833263.7705.28.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-04 at 20:58 +0000, Artem S. Tashkinov wrote:
> Hello everyone,
> 
> I feel a little bit stupid and surprised but supposedly I should have sched_mc_power_savings files in my /sys since I have CONFIG_SCHED_MC defined in my .config and I have a four cores CPU (to be exact Intel Core i5 2500).
> 
> Alas, under Linux kernel 3.0-rc5 I don't have the aforementioned files.
> 
> Is something wrong going on here?

No, it's normal, and appears only when you have multiple CPU packages.

	-Mike

