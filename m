Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab2JAKTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:19:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58385 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752718Ab2JAKTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:19:02 -0400
Date: Mon, 1 Oct 2012 11:19:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: silence GCC warning
Message-ID: <20121001101859.GC4360@opensource.wolfsonmicro.com>
References: <1349000155.1553.27.camel@x61.thuisdomein>
 <20121001100321.GB4360@opensource.wolfsonmicro.com>
 <1349086606.24442.13.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349086606.24442.13.camel@x61.thuisdomein>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 12:16:46PM +0200, Paul Bolle wrote:
> On Mon, 2012-10-01 at 11:03 +0100, Mark Brown wrote:

> > Have you reported this bug in GCC?

> No I haven't. Since you ask, I guess you too think 'ret' is always set
> when this function returns, don't you? Ie, my analysis isn't obviously
> wrong.

I haven't actually stared hard enough at the code to figure this out
yet but given what you're changing I'd hope it's a flow analysis bug.
I'm certainly not seeing a warning here.
