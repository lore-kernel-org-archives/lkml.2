Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339Ab0GWNOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 09:14:18 -0400
Received: from mail.tpi.com ([70.99.223.143]:4792 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754Ab0GWNOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 09:14:16 -0400
Message-ID: <4C49958E.6060808@mail.tpi.com>
Date: Fri, 23 Jul 2010 15:13:50 +0200
From: Tim Gardner <tcanonical@tpi.com>
Reply-To: tim.gardner@canonical.com
Organization: Canonical, Ltd
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Petr Pisar <petr.pisar@atlas.cz>
Subject: Re: [Bug #16111] hostap_pci: infinite registered netdevice wifi0
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera> <PRbv8sgxY6G.A.kQG.0VYSMB@chimera>
In-Reply-To: <PRbv8sgxY6G.A.kQG.0VYSMB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2010 02:15 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.33 and 2.6.34.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16111
> Subject		: hostap_pci: infinite registered netdevice wifi0
> Submitter	: Petr Pisar<petr.pisar@atlas.cz>
> Date		: 2010-06-02 20:55 (52 days old)
> Handled-By	: Tim Gardner<tim.gardner@canonical.com>
> 		Petr Pisar<petr.pisar@atlas.cz>
> Patch		: https://patchwork.kernel.org/patch/105008/
> 		  https://bugzilla.kernel.org/attachment.cgi?id=27109
>
>

Commit d6a574ff6bfb842bdb98065da053881ff527be46 in Linus' tree

-- 
Tim Gardner tim.gardner@canonical.com
