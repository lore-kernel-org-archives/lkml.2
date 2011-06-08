Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab1FHTvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:51:05 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41491 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776Ab1FHTvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:51:02 -0400
Message-ID: <4DEFD29E.9090904@ti.com>
Date: Wed, 8 Jun 2011 20:50:54 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Margarita Olaya <magi@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: Re: [PATCHv4 0/4][RESEND] Initial support for TPS65912 PMIC
References: <BANLkTik5VNxPZecoPyR4N-kbfvMz5JMBuA@mail.gmail.com>
In-Reply-To: <BANLkTik5VNxPZecoPyR4N-kbfvMz5JMBuA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/11 18:42, Margarita Olaya wrote:
> Hi,
> 
> This is the initial version of the TPS65912 PMIC, a power management IC
> for multimedia products.
> 
> The tps65912 consists of 4 DCDCs and 10 LDOs, that are able to supply
> voltage to main processor and other components. The chip includes a
> GPIO module.
> 
> -- Resend v4
> 

Samuel, you have my Ack for upstreaming all via MFD if that's OK with you.

Acked-by: Liam Girdwood <lrg@ti.com>

Thanks !

Liam
