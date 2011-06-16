Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab1FPKWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 06:22:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54235 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754099Ab1FPKWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 06:22:12 -0400
Date: Thu, 16 Jun 2011 11:22:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, grant@secretlab.ca
Subject: Re: [PATCH] FRV: Hook up gpiolib support
Message-ID: <20110616102209.GC5262@opensource.wolfsonmicro.com>
References: <20110615144823.GA2806@opensource.wolfsonmicro.com>
 <1306921767-31115-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <5194.1308074912@redhat.com>
 <19624.1308206191@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19624.1308206191@redhat.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 07:36:31AM +0100, David Howells wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > Could you be more specific about the issue you see here?

> I was specific:

> 	Take gpio_get_value() for instance, it requires __gpio_get_value() -
> 	which is defined by the asm-generic header - but is used by
> 	gpio_get_value_cansleep() in the asm-generic header.

> gpio_get_value() is defined in the arch header.

And to repeat what I said: the generic header prototypes everything it
needs before it uses it so there should be no problem here, it's not
been a problem on the other architectures using this code verbatim.
Please be more specific.

If there's some problem none of the tools notice or some FRV specific
issue you're going to have to tell us what it is.
