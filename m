Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab0LOQni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:43:38 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42155 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab0LOQnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:43:35 -0500
Date: Wed, 15 Dec 2010 16:43:16 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Dave Martin <dave.martin@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the arm tree with the arm-current
	tree
Message-ID: <20101215164316.GA5641@flint.arm.linux.org.uk>
References: <20101215105435.3ce83f21.sfr@canb.auug.org.au> <20101214235746.GB21913@flint.arm.linux.org.uk> <AANLkTimdZ3FRs82RzSZR19gDJbkNe2UfEY-kLQOwvd_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimdZ3FRs82RzSZR19gDJbkNe2UfEY-kLQOwvd_Q@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 12:28:39PM +0000, Dave Martin wrote:
> Hi,
> 
> On Tue, Dec 14, 2010 at 11:57 PM, Russell King <rmk@arm.linux.org.uk> wrote:
> > On Wed, Dec 15, 2010 at 10:54:35AM +1100, Stephen Rothwell wrote:
> >> Hi Russell,
> >>
> >> Today's linux-next merge of the arm tree got a conflict in
> >> arch/arm/Kconfig between commit 6e6fc998b8c127fe06b9350a1f16e41bfe4f109d
> >> ("ARM: 6533/1: Thumb-2: Make CONFIG_THUMB2_KERNEL depend on !CPU_V6")
> >> from the arm-current tree and commit
> >> 4a50bfe365a977f634311504484342fbfffe855c ("ARM: Ensure experimental
> >> options are so marked") from the arm tree.
> >>
> >> Just context changes.  I fixed it up (see below) and can carry the fix as
> >> necessary.
> >
> > Yea, rather unfortunate.  I'll fix it up locally once arm-current is
> > merged into mainline.
> 
> Looks like this was a case of two simple changes on neighbouring lines
> -- I'll try to avoid such conflicts for the future.

It's not a problem.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
