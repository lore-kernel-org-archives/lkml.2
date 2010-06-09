Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab0FIQc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 12:32:27 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:46971 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757950Ab0FIQcZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:32:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=DiqIz5piUA95a9F6vtc3ugZhNieFOyzUwtHC5Ol+QaNC6FmEgcJsw4JdBXo/735Amci1/DvSacdMDkhOciiYBy7WPcGmDFOd+DOa7CaWVJVSTcyvP96ucatrXuuhj5ax;
Date: Wed, 9 Jun 2010 09:31:18 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       platform-driver-x86@vger.kernel.org
Subject: Re: [GIT PULL] x86 platform driver updates for 2.6.35-rc3
Message-ID: <20100609093118.784f3683@virtuousgeek.org>
In-Reply-To: <AANLkTin45ibtZoThRwOG3eTjFmT0LJ4gKS-ExXqpKx2v@mail.gmail.com>
References: <20100608221901.GA25294@srcf.ucam.org>
	<alpine.LFD.2.00.1006081806040.4506@i5.linux-foundation.org>
	<20100608182456.3e681359@virtuousgeek.org>
	<alpine.LFD.2.00.1006081855170.4506@i5.linux-foundation.org>
	<AANLkTin45ibtZoThRwOG3eTjFmT0LJ4gKS-ExXqpKx2v@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jun 2010 12:03:55 +1000
Dave Airlie <airlied@gmail.com> wrote:

> On Wed, Jun 9, 2010 at 11:57 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> >
> > On Tue, 8 Jun 2010, Jesse Barnes wrote:
> >>
> >> FWIW this is the "make ironlake go fast" driver.  It interacts with the
> >> i915 driver to increase graphics performance significantly.  But yeah,
> >> Matthew and I didn't get it integrated into his tree in time for the
> >> merge window, so I understand if you don't want it right now.
> >
> > I'm not great at all the intel code-names. Is ironlake the expected-Q4
> > on-die GPU or the current one?
> >
> > Not that I'd prefer to pull it even if it's the current one, but if it's
> > the next-gen one then we're in even less of a hurry, I think.
> >
> 
> Its probably the one on your desk, its at least the one in the two
> laptops on mine.
> 
> So definitely now-gen.

Right, Ironlake is the class of graphics chips found in Core i3/5/7
with HD graphics, which are shipping in volume now.

The IPS driver is mostly standalone, but it does make some calls into
the i915 driver to increase or decrease available graphics frequencies,
so it's not a clear cut case of a new driver and does introduce some
risk.

-- 
Jesse Barnes, Intel Open Source Technology Center
