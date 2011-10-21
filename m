Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab1JULM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 07:12:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39224 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754310Ab1JULM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 07:12:26 -0400
Date: Fri, 21 Oct 2011 12:12:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: "Girdwood, Liam" <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v7 2/3] ASoC: da7210: Add support for line
 out and DAC
Message-ID: <20111021111223.GD4080@opensource.wolfsonmicro.com>
References: <1319121769.24621.130.camel@matrix>
 <CABS+qY3zsuQSE_9=_jaoO=AYRyopZ3WPNeG-PJYzwucmWxcqkA@mail.gmail.com>
 <1319186260.24621.154.camel@matrix>
 <20111021090054.GF3513@opensource.wolfsonmicro.com>
 <1319190555.24621.160.camel@matrix>
 <20111021102429.GB4080@opensource.wolfsonmicro.com>
 <1319195132.24621.198.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319195132.24621.198.camel@matrix>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 04:35:32PM +0530, Ashish Chavan wrote:

> Yes, your understanding is correct. Actually I acted bit lazy here by
> not splitting, assuming that both patches are going to get merged
> shortly. Do you think is it mandatory to do that? Or can I repost the
> patch after just resolving merge issue?

It's better to refactor, it makes review much easier.
