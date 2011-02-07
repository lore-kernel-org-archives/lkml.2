Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab1BGOSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 09:18:33 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33866 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752693Ab1BGOSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 09:18:32 -0500
Date: Mon, 7 Feb 2011 14:18:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] PM: Hide CONFIG_PM from users
Message-ID: <20110207141829.GK10564@opensource.wolfsonmicro.com>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110208011324.d5371c4c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110208011324.d5371c4c.sfr@canb.auug.org.au>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 01:13:24AM +1100, Stephen Rothwell wrote:
> On Mon,  7 Feb 2011 12:22:15 +0000 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > +	bool
> > +	default y if !IA64_HP_SIM

> Several powerpc configs have CONFIG_PM (implicitly) disabled (e.g. the
> server configs), so this will unexpectedly turn it on for them.

Do you mean that these systems require CONFIG_PM be turned off, or just
that people tend not to turn it on?  If the latter would you expect any
ill effects from doing so?
