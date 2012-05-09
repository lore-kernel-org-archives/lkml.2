Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab2EIAHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 20:07:39 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51787 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab2EIAHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 20:07:37 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+xKPDlsCUoZ2nJja03oW8G
Date: Tue, 8 May 2012 17:07:34 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lauri Leukkunen <lauri.leukkunen@nokia.com>,
        Sebastian Reichel <sre@debian.org>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Ameya Palande <ameya.palande@nokia.com>
Subject: Re: rx51: support for lis3lv02d accelerometer
Message-ID: <20120509000734.GZ5088@atomide.com>
References: <1621273.5PNGJFOirm@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1621273.5PNGJFOirm@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [120504 08:41]:
> Hi!
> 
> Upstream linux kernel has already driver for lis3lv02d accelerometer
> in drivers/misc/lis3lv02d. So now can be added also platform support
> for nokia rx51. Patch exists for long time in meego obs repository:
> https://build.pub.meego.com/package/view_file?file=linux-2.6-omap-rx51-Platform-support-for-lis3lv02d-acceleromet.patch&package=kernel-adaptation-n900&project=CE%3AAdaptation%3AN900
> 
> It is possible to include this patch to upstream kernel?

Thanks, applying into board branch with From: Ameya as in the
link above.

Regards,

Tony
