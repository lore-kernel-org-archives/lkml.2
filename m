Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab1ERVsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:48:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:42521 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743Ab1ERVs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:48:29 -0400
Subject: Re: powerpc: mpc85xx regression since 2.6.39-rc2, one cpu core lame
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Milton Miller <miltonm@bga.com>
Cc: Richard Cochran <richardcochran@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Kumar Gala <galak@kernel.crashing.org>,
        Kerstin Jonsson <kerstin.jonsson@ericsson.com>
In-Reply-To: <1305739191_6593@mail4.comsite.net>
References: <20110517162827.GA16918@riccoc20.at.omicron.at>
	 <1305668416.2781.23.camel@pasglo>
	 <20110518120320.GA3025@riccoc20.at.omicron.at>
	 <1305739191_6593@mail4.comsite.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 07:48:10 +1000
Message-ID: <1305755290.7481.7.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 12:19 -0500, Milton Miller wrote:
> Does this patch help?  If so please reply to that thread so patchwork
> will see it in addition to here.
> 
> http://patchwork.ozlabs.org/patch/96146/

Interesting. I'll have a closer look today. Unfortunately, I don't have
any 32-bit BookE SMP at hand at the moment so I couldn't test those
configs.

Cheers,
Ben.


