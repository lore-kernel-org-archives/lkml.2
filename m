Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771Ab0G3UUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 16:20:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54929 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760760Ab0G3UUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 16:20:53 -0400
Date: Fri, 30 Jul 2010 21:20:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Steve Muckle <smuckle@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tony Lindgren <tony@atomide.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 2/3] arm: mm: do not set missing flags on ScorpionMP
Message-ID: <20100730202029.GB15062@n2100.arm.linux.org.uk>
References: <1279911483-7039-1-git-send-email-johlstei@codeaurora.org> <1279911483-7039-3-git-send-email-johlstei@codeaurora.org> <20100724082334.GB15571@n2100.arm.linux.org.uk> <1280354280.21185.10.camel@c-dwalke-linux.qualcomm.com> <20100728223603.GB6729@n2100.arm.linux.org.uk> <1280357495.21185.26.camel@c-dwalke-linux.qualcomm.com> <20100729071818.GC6729@n2100.arm.linux.org.uk> <1280443366.27035.14.camel@c-dwalke-linux.qualcomm.com> <20100730071910.GC29746@n2100.arm.linux.org.uk> <1280509777.4142.3.camel@m0nster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280509777.4142.3.camel@m0nster>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 10:09:37AM -0700, Daniel Walker wrote:
> On Fri, 2010-07-30 at 08:19 +0100, Russell King - ARM Linux wrote:
> > Yes, but if its just for this patch, is there much point to a pull
> > request?
> 
> I've got some other stuff too .. Jeff Ohlstein sent several patches (one
> of which started this discussion), which are needed for an SMP board
> we've been working on.

Has it been seen on the mailing list?
