Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab2JATMC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 15:12:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53247 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792Ab2JATMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 15:12:01 -0400
Date: Mon, 1 Oct 2012 20:11:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: silence GCC warning
Message-ID: <20121001191158.GT4360@opensource.wolfsonmicro.com>
References: <1349000155.1553.27.camel@x61.thuisdomein>
 <20121001100321.GB4360@opensource.wolfsonmicro.com>
 <1349086606.24442.13.camel@x61.thuisdomein>
 <20121001101859.GC4360@opensource.wolfsonmicro.com>
 <1349087577.24442.21.camel@x61.thuisdomein>
 <20121001113927.GJ4360@opensource.wolfsonmicro.com>
 <1349118537.1414.22.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349118537.1414.22.camel@x61.thuisdomein>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 09:08:57PM +0200, Paul Bolle wrote:

> from cached registers"). The first release shipping that commit was
> v3.4. The log of a build of v3.4 using the oldest version of GCC (that
> Fedora used to build v3.4) I could find also contains this warning [0].
> They used gcc-4.6.3-2.fc16.x86_64 in that build [1].

> Perhaps I'll stumble on some build logs of v3.4 for which earlier
> versions of GCC were used. That might show whether or not earlier
> releases of GCC also print a warning for this code.

I'm using GCC 4.4.1 on ARM which seems quite happy.
