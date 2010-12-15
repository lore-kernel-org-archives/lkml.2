Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab0LOODu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:03:50 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40744 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab0LOODs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:03:48 -0500
Date: Wed, 15 Dec 2010 14:03:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>
Subject: Re: linux-next: build failure after merge of the voltage tree
Message-ID: <20101215140344.GF5723@sirena.org.uk>
References: <20101215130911.e6edddfe.sfr@canb.auug.org.au> <1292403884.3348.6.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292403884.3348.6.camel@odin>
X-Cookie: $3,000,000.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 09:04:44AM +0000, Liam Girdwood wrote:

> Yong, can you send a patch *today* that fixes the modular build for
> this.

Looks like he's not going to get a chance to do that, I'm cooking up
some patches just now which should deal with the issue.
