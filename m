Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab1IOHvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 03:51:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54870 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755167Ab1IOHvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 03:51:50 -0400
Date: Thu, 15 Sep 2011 08:51:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regulator constraints and userspace consumer
Message-ID: <20110915075147.GA5040@opensource.wolfsonmicro.com>
References: <CAM8FrKKEXUwV6=cMzqi0Le7eadb2XWkrjSQ+jm=QBUJMGPKztQ@mail.gmail.com>
 <20110914232706.GB2953@opensource.wolfsonmicro.com>
 <CAM8FrKJbf-FhBrEs+YScF3rZFSa4_vzPAbaFP+2hB2qjXGSmNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM8FrKJbf-FhBrEs+YScF3rZFSa4_vzPAbaFP+2hB2qjXGSmNg@mail.gmail.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 07:21:24AM +0200, Marcus Folkesson wrote:

> We are working on an Software Defined Radio (SDR) in which power
> consumption is an important part of the product.
> The "modem" application executes in user space and has the
> responsibility to turn the voltage regulators on/off to the radio card
> and so on.
> When the application goes into power-down mode, there are circuits
> that are not used and we are able to reduce the voltage further by set
> down a few boost regulators.

I'd expect you have some sort of kernel mode driver for the hardware
side of things - shouldn't that be able to manage the regulators for
you?  What happens when someone deploys the software on a different
board?
