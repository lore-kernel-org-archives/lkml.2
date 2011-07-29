Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab1G2AhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 20:37:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39368 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab1G2AhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 20:37:06 -0400
Date: Fri, 29 Jul 2011 02:37:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: matsumur@nts.ricoh.co.jp
Cc: andi@firstfloor.org, ak@linux.intel.com, cjb@laptop.org,
        daniel.manrique@canonical.com, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, manoj.iyer@canonical.com,
        stable@kernel.org, tim.bird@am.sony.com
Subject: Re: [PATCH] [9/50] mmc: Added quirks for Ricoh 1180:e823 lower base clock
Message-ID: <20110729003703.GM8006@one.firstfloor.org>
References: <20110728234413.75CBB2403FF@tassilo.jf.intel.com> <OFEA694ED7.D779260D-ON492578DB.00834494-492578DC.000262D4@mta.ricoh.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFEA694ED7.D779260D-ON492578DB.00834494-492578DC.000262D4@mta.ricoh.co.jp>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 09:27:56AM +0900, matsumur@nts.ricoh.co.jp wrote:
> Dear Sir,
> 
> Ricoh 1180:e823 device is named R5U220/R5U232 (2 devices have the same
> device ID ).
> So, I think it should be declared to as PCI_DEVICE_ID_RICOH_R5U220.

Is that just the wrong name or will it actually cause misfunction?

I will keep it if it's just the wrong name, but the name should be probably
fixed upstream.

-Andi
