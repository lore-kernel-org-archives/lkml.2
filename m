Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab2JFIxL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:53:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51954 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754287Ab2JFIxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:53:08 -0400
Date: Sat, 6 Oct 2012 09:53:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Valdis.Kletnieks@vt.edu
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: silence GCC warning
Message-ID: <20121006085306.GB8590@opensource.wolfsonmicro.com>
References: <1349000155.1553.27.camel@x61.thuisdomein>
 <20121001100321.GB4360@opensource.wolfsonmicro.com>
 <64681.1349223065@turing-police.cc.vt.edu>
 <1349249016.1414.55.camel@x61.thuisdomein>
 <59004.1349475644@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59004.1349475644@turing-police.cc.vt.edu>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 06:20:44PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 03 Oct 2012 09:23:36 +0200, Paul Bolle said:

> > That is another way to silence GCC here.

> That's probably a preferable approach - that way, if a bogus val_count gets
> passed in, the caller will be informed of the fact.  Which is a lot better than
> just papering over the warning.

As I hinted earlier if someone were to send me a patch...
