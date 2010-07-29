Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab0G2SI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 14:08:58 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:42014 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753821Ab0G2SI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 14:08:56 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAG5fUUzZiBZX/2dsb2JhbACgCXLAYA2FKwQ
Date: Thu, 29 Jul 2010 20:08:54 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
        wim@iguana.be, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Marc Zyngier <maz@misterjones.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH 7/7] watchdog: Add watchdog driver for OCTEON SOCs.
Message-ID: <20100729180854.GE30740@infomag.iguana.be>
References: <1279935707-3997-1-git-send-email-ddaney@caviumnetworks.com> <1279935707-3997-8-git-send-email-ddaney@caviumnetworks.com> <20100724030754.GG7217@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100724030754.GG7217@linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralf,

Will review tomorrow, but if OK then it can indeed go via MIPS tree.

Kind regards,
Wim.

> On Fri, Jul 23, 2010 at 06:41:47PM -0700, David Daney wrote:
> 
> Wim, ok to merge this one through the MIPS tree?
> 
>   Ralf
