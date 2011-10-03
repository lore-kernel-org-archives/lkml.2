Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab1JCIkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 04:40:16 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44773 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab1JCIkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 04:40:10 -0400
MIME-Version: 1.0
In-Reply-To: <20110928123154.GG3279@opensource.wolfsonmicro.com>
References: <20110921131637.GF4374@opensource.wolfsonmicro.com>
	<CAMLZHHTJaOddSj00g0-WpFQu6pUTqizKjKaQF9hLrhceEMhY1Q@mail.gmail.com>
	<20110927150555.GF20588@ponder.secretlab.ca>
	<CAMLZHHQU-eMAtvBQJj6+WrMjkWWA+ET=z5NdQCEgXxh=m10d3Q@mail.gmail.com>
	<20110927181420.GQ4289@opensource.wolfsonmicro.com>
	<CAMLZHHSuoeAJ-AC9daxb83+EANV=YGK-aiYpQ_j2wFiyQa5ytw@mail.gmail.com>
	<20110927182636.GR4289@opensource.wolfsonmicro.com>
	<CAMLZHHR0rMZct2E91X8k+Lhv_y-pY_5+vshZw6dj194o9vSCJQ@mail.gmail.com>
	<20110927183832.GS4289@opensource.wolfsonmicro.com>
	<CAMLZHHRvr-diYGwZ2Kg647Ht7NNb8LEku0pCW8EujRuUeOW5yQ@mail.gmail.com>
	<20110928123154.GG3279@opensource.wolfsonmicro.com>
Date: Mon, 3 Oct 2011 09:40:10 +0100
X-Google-Sender-Auth: EgRGGu82I1nff8FqhYtBvY0aPiY
Message-ID: <CAMLZHHRFY_MazF_MOzPrS06z-48-ohORTtbANMxUT=mjevXhhQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: allow mfd_cell association with device tree node
From: Daniel Drake <dsd@laptop.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 1:31 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> Right, but your modification was to the MFD core so it's going to affect
> other devices...

But only when they start using the newly added functionality. At this
point, it affects nobody except vx855.

Grant, any chance I could have your comments on the latest patches?
http://marc.info/?l=linux-kernel&m=131720353308737&w=2
http://marc.info/?l=linux-kernel&m=131720341808574&w=2
http://marc.info/?l=linux-kernel&m=131720093305636&w=2

Thanks,
Daniel
