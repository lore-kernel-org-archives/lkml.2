Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab0DOSZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:25:06 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:57388 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752330Ab0DOSZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:25:04 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABf3xktbstG6/2dsb2JhbACbanK/Lw2FAQQ
Date: Thu, 15 Apr 2010 20:25:02 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Marc Zyngier <maz@misterjones.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] watchdog/max63xx: be careful when disabling the
	watchdog
Message-ID: <20100415182502.GF15728@infomag.iguana.be>
References: <b618a3827c2a4d627640f260cca3c71a@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b618a3827c2a4d627640f260cca3c71a@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

> The attached patch fixes a nasty error with the max63xx driver,
> potentially leaving the platform dead (and watchdog disabled...).

Will add that fix also.

Kind regards,
Wim.

