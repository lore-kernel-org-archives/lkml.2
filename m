Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab1I0S2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:28:45 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44519 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab1I0S2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:28:41 -0400
MIME-Version: 1.0
In-Reply-To: <20110927182636.GR4289@opensource.wolfsonmicro.com>
References: <20110921120148.4A81E9D401D@zog.reactivated.net>
	<20110921124936.GA25620@sirena.org.uk>
	<CAMLZHHQZnajC4e12MjaK3W8WcAB2ZB+6L=5kS5BBFZF=+YWicQ@mail.gmail.com>
	<20110921131637.GF4374@opensource.wolfsonmicro.com>
	<CAMLZHHTJaOddSj00g0-WpFQu6pUTqizKjKaQF9hLrhceEMhY1Q@mail.gmail.com>
	<20110927150555.GF20588@ponder.secretlab.ca>
	<CAMLZHHQU-eMAtvBQJj6+WrMjkWWA+ET=z5NdQCEgXxh=m10d3Q@mail.gmail.com>
	<20110927181420.GQ4289@opensource.wolfsonmicro.com>
	<CAMLZHHSuoeAJ-AC9daxb83+EANV=YGK-aiYpQ_j2wFiyQa5ytw@mail.gmail.com>
	<20110927182636.GR4289@opensource.wolfsonmicro.com>
Date: Tue, 27 Sep 2011 19:28:40 +0100
X-Google-Sender-Auth: o2ax8nukhm5vNxR-w242QTpZSc4
Message-ID: <CAMLZHHR0rMZct2E91X8k+Lhv_y-pY_5+vshZw6dj194o9vSCJQ@mail.gmail.com>
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

On Tue, Sep 27, 2011 at 7:26 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> That seems like a bug that just happened to get noticed while reviewing
> this change, though...

Sorry if I'm missing something obvious but I'm not seeing the issue.
What exactly is this bug and what effects could it cause?

Thanks,
Daniel
