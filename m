Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab0IQPy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:54:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51270 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755067Ab0IQPy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:54:27 -0400
Date: Fri, 17 Sep 2010 16:54:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: mahatma@eu.by
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: i2c: Re: #2 (Re: More modaliases + patchtool))
Message-ID: <20100917155424.GA29596@rakim.wolfsonmicro.main>
References: <4C6BE292.3060307@bspu.unibel.by>
 <201008191020.52861.rusty@rustcorp.com.au>
 <4C6D26BC.9040805@bspu.unibel.by>
 <201009111144.34078.rusty@rustcorp.com.au>
 <4C936EA5.2040506@bspu.unibel.by>
 <20100917140647.GA18367@opensource.wolfsonmicro.com>
 <4C938D9D.4070709@bspu.unibel.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C938D9D.4070709@bspu.unibel.by>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 06:47:41PM +0300, Dzianis Kahanovich wrote:
> Mark Brown пишет:
> 
> >> + 1 attach for "next" branch.

> > Again, please try to follow the process in SubmittingPatches for sending
> > patches.

> One thing (patch) per message?

The bits about CCing the relevant maintainers and the actual format of
the e-mail (subject line, patch in the body of the message and adding
text not for the actual changelog after the ---).

> > This change is OK but should be moved next to the actual table.

> This means - after:
> static const struct i2c_device_id tlv320dac33_i2c_id[] = {

Yes.
