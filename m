Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab1ISRAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 13:00:01 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33176 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab1ISRAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 13:00:00 -0400
Date: Mon, 19 Sep 2011 17:59:43 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Cc: Rabin Vincent <rabin@rab.in>, lk <linux-kernel@vger.kernel.org>,
        lak <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: BUG() dies silently
Message-ID: <20110919165943.GX16381@n2100.arm.linux.org.uk>
References: <1301602523-9906-1-git-send-email-omar.ramirez@ti.com> <CAH+eYFBSiL44CMOpgED+TAOTUH_dQMaKKu=hC3ynG0Y2nQ8ekw@mail.gmail.com> <CAB-zwWi1K8y8fHzy0hgcFPgSfhMrZNfoKQ9xuU00Y1sLg6ZBmw@mail.gmail.com> <20110919144313.GU16381@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110919144313.GU16381@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 03:43:13PM +0100, Russell King - ARM Linux wrote:
> On Mon, Sep 19, 2011 at 09:26:49AM -0500, Ramirez Luna, Omar wrote:
> > Hi
> > 
> > On Sat, Sep 17, 2011 at 1:07 AM, Rabin Vincent <rabin@rab.in> wrote:
> > > If the "Use generic BUG() handler" patch is only scheduled for the next
> > > merge window and not for 3.1, can this patch be merged instead for 3.1
> > > and -stable?  This problem is easily seen with GCC 4.6.
> > 
> > I can send it for both and let the maintainers decide.
> > 
> > Russell, do you give your ack?
> 
> I think it's too large a change for -stable and 3.1 - let's get it into
> 3.2 first, and make sure no one sees any regressions there.  Then we can
> think about submitting it to stable once its proven itself.

And we're seeing link failures with the patch in the kernel, so it's
*definitely* not stable material as it stands, even if the current code
is a problem for GCC 4.6.

Regressions trump bug fixes.
