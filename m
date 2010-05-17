Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab0EQIbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 04:31:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:43511 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab0EQIbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 04:31:41 -0400
Subject: Re: [lm-sensors] Simple fan question
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Pavel Machek <pavel@ucw.cz>, lm-sensors@lm-sensors.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100517101407.193b93f2@hyperion.delvare>
References: <1272518506.24542.163.camel@pasglop>
	 <20100429105740.6e3b7716@hyperion.delvare>
	 <1272581806.24542.185.camel@pasglop> <20100517074621.GA14520@ucw.cz>
	 <20100517101407.193b93f2@hyperion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 18:30:34 +1000
Message-ID: <1274085034.21352.721.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 10:14 +0200, Jean Delvare wrote:
> If you have 100 different values, you can map them to the standard
> 0..255 range of pwm[1-*] files.
> 
> > IIRC thinkpads have 8-or-so possible discrete cases...
> 
> Correct. And even these would map nicely to the 0..255 range IMHO.

well, I eventually settled for doing that with my 3 values :-) We'll see
how fan-control copes.

Cheers,
Ben.


