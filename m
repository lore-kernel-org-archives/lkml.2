Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab1BAQs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 11:48:29 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:44602 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075Ab1BAQs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:48:28 -0500
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC][PATCH] Power domains for platform bus type
Organization: Texas Instruments, Inc.
References: <201101300107.19389.rjw@sisk.pl> <871v3s3ahe.fsf@ti.com>
	<AANLkTinEsUOZQURXOfAVoTU5=k0mi8PC0_Gte6gACDFj@mail.gmail.com>
	<201102011158.46312.rjw@sisk.pl>
Date: Tue, 01 Feb 2011 08:48:14 -0800
In-Reply-To: <201102011158.46312.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Tue, 1 Feb 2011 11:58:46 +0100")
Message-ID: <87sjw7wvjl.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

[...]

> Also, I'm going to move the power domain hook to the struct device level, so
> that we have:
>
> struct device {
>     ...
>     struct power_domain *domain;
>     ...
> };
>
> struct power_domain {
>     struct dev_pm_ops ops;
> };
>

Great, thanks.

Any opinion on my idea to name this 'struct dev_power_domain' to avoid
confusion with existing powerdomain structs in SoC code?  For example,
on OMAP we already have a 'struct powerdomain'.

Kevin
