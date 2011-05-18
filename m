Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab1ERVtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:49:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:42538 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743Ab1ERVtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:49:08 -0400
Subject: Re: powerpc: mpc85xx regression since 2.6.39-rc2, one cpu core lame
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110518120320.GA3025@riccoc20.at.omicron.at>
References: <20110517162827.GA16918@riccoc20.at.omicron.at>
	 <1305668416.2781.23.camel@pasglop>
	 <20110518120320.GA3025@riccoc20.at.omicron.at>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 07:48:58 +1000
Message-ID: <1305755338.7481.8.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> (I get the feeling that I am the only one testing recent kernels with
> the mpc85xx.)
> 
> Anyhow, I see that this commit was one of a series. For my own use,
> can I simply revert this one commit independently?

For your own use sure :-) But I'd still like to get to the bottom of
this !

Cheers,
Ben.

