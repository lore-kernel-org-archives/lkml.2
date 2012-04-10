Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab2DJNMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 09:12:15 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49795 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758701Ab2DJNMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 09:12:13 -0400
Date: Tue, 10 Apr 2012 14:12:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
Message-ID: <20120410131206.GB31551@sirena.org.uk>
References: <20120410131930.28186.85370.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410131930.28186.85370.stgit@bob.linux.org.uk>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 02:20:05PM +0100, Alan Cox wrote:
> This ended in a discussion of where shall we put it and then silence so
> resending this because we still need it and we've got patches that depend
> upon it getting backlogged.

The decision seems fairly settled that general purpose ADCs like this
should go into IIO, the trick is going to be getting IIO out of staging.
