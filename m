Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab0JYWJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 18:09:48 -0400
Received: from mx7.orcon.net.nz ([219.88.242.57]:47848 "EHLO mx7.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab0JYWJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 18:09:45 -0400
Cc: linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>,
        linux-alpha@vger.kernel.org
Message-Id: <4A366B22-C911-4BCD-B052-0278E94824D5@orcon.net.nz>
From: Michael Cree <mcree@orcon.net.nz>
To: Kyle McMartin <kyle@mcmartin.ca>
In-Reply-To: <20101014222805.GA8332@bombadil.infradead.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH 0/3] alpha: __do_IRQ just say no
Date: Tue, 26 Oct 2010 11:09:38 +1300
References: <20101014222805.GA8332@bombadil.infradead.org>
X-Mailer: Apple Mail (2.936)
X-DSPAM-Check: by mx7.orcon.net.nz on Tue, 26 Oct 2010 11:09:43 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Oct 26 11:09:43 2010
X-DSPAM-Confidence: 0.6514
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/10/2010, at 11:28 AM, Kyle McMartin wrote:
> Please test and review the following changes which convert alpha away
> from calling __do_IRQ, which is deprecated and will be nuked at some
> point in the future.

I had this running on a PWS600au for a few hours without any problems  
showing up.  That tests the generic Alpha code and the irq_pyxis and  
irq_i8259 machine specific code.

Tested-by: Michael Cree <mcree@orcon.net.nz>

Cheers
Michael.

