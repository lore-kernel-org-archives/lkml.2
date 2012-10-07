Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab2JGVwE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 17:52:04 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46494 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751680Ab2JGVwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 17:52:02 -0400
Message-ID: <1349646718.15802.16.camel@joe-AO722>
Subject: Re: [PATCH 13/13] drivers/media/tuners/e4000.c: use macros for
 i2c_msg initialization
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: walter harms <wharms@bfs.de>, Antti Palosaari <crope@iki.fi>,
        kernel-janitors@vger.kernel.org, rmallon@gmail.com,
        shubhrajyoti@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 07 Oct 2012 14:51:58 -0700
In-Reply-To: <alpine.DEB.2.02.1210072342460.2745@localhost6.localdomain6>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1349624323-15584-3-git-send-email-Julia.Lawall@lip6.fr>
	 <5071AEF3.6080108@bfs.de>
	 <alpine.DEB.2.02.1210071839040.2745@localhost6.localdomain6>
	 <5071B834.1010200@bfs.de>
	 <alpine.DEB.2.02.1210071917040.2745@localhost6.localdomain6>
	 <1349633780.15802.8.camel@joe-AO722>
	 <alpine.DEB.2.02.1210072053550.2745@localhost6.localdomain6>
	 <1349645970.15802.12.camel@joe-AO722>
	 <alpine.DEB.2.02.1210072342460.2745@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-10-07 at 23:43 +0200, Julia Lawall wrote:
> On Sun, 7 Oct 2012, Joe Perches wrote:
> >> Are READ and WRITE the action names?  They are really the important
> >> information in this case.
> >
> > Yes, most (all?) uses of _READ and _WRITE macros actually
> > perform some I/O.
> 
> I2C_MSG_READ_DATA?
> I2C_MSG_READ_INFO?
> I2C_MSG_READ_INIT?
> I2C_MSG_PREPARE_READ?

Dunno, naming is hard.  Maybe:

I2C_INPUT_MSG
I2C_OUTPUT_MSG
I2C_OP_MSG

cheers, Joe



