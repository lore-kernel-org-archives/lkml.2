Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965443Ab1C3Vp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:45:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:39222 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965426Ab1C3Vp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:45:56 -0400
Subject: Re: [GIT pull] irq fixes for .39.rc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <AANLkTinnGfpVeugk4WOKeDAUQEuzBo75yCq_E73=w66V@mail.gmail.com>
References: <alpine.LFD.2.00.1103301648460.22418@localhost6.localdomain6>
	 <AANLkTinnGfpVeugk4WOKeDAUQEuzBo75yCq_E73=w66V@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 Mar 2011 08:45:23 +1100
Message-ID: <1301521523.2407.4.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 08:36 -0700, Linus Torvalds wrote:
> 
> which just makes me go "Somebody is really really confused".
> 
> The whole thing may mean that both handler_data and chip_data contains
> the right thing, but it still makes me go "WTF?".
> 
> Which way should I resolve it? 

Looks like I'm the one who mixed up here.

Kumar: shows that you are overdue for sending me some FSL HW so I can
test things :-)

Cheers,
Ben.


