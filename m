Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab1BPPKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 10:10:50 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33444 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751811Ab1BPPKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 10:10:48 -0500
X-Sasl-enc: vsuefZXCWKuOkBc9WqinroxN08u3ppyIxFMa7jPzcmsA 1297869047
Message-ID: <4D5BE927.7000306@ladisch.de>
Date: Wed, 16 Feb 2011 16:11:35 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 3/3] hwmon: (jc42) do not allow writing to
 locked registers
References: <4D5BCA87.7010204@ladisch.de> <4D5BCAEE.6030502@ladisch.de> <20110216145049.GC13872@ericsson.com>
In-Reply-To: <20110216145049.GC13872@ericsson.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter Roeck wrote:
> On Wed, Feb 16, 2011 at 08:02:38AM -0500, Clemens Ladisch wrote:
> > +		readonly = config & JC42_CFG_TCRIT_LOCK;
> 
> You are assigning a non-bool to a bool. I can see that recent C compilers
> do the right thing, but I am not sure if that is always the case.
> So I would prefer
> 		readonly = !!(config & JC42_CFG_TCRIT_LOCK));
> 
> Same for the assignments below. I can make that change if you are ok with it.

I cannot imagine how a compiler could get this wrong even if it tried
to, but if you think so, go ahead.  :)


Regards,
Clemens
