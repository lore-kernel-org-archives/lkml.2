Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab2ABM6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 07:58:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38104 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014Ab2ABM6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 07:58:19 -0500
Date: Mon, 2 Jan 2012 12:58:15 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v8 3/3 RESEND] ASoC: da7210: Add support for
 line input and mic
Message-ID: <20120102125815.GI4300@opensource.wolfsonmicro.com>
References: <1325505952.12508.12.camel@matrix>
 <20120102120024.GH2899@opensource.wolfsonmicro.com>
 <1325506569.12508.15.camel@matrix>
 <20120102121117.GI2899@opensource.wolfsonmicro.com>
 <1325508002.12508.30.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325508002.12508.30.camel@matrix>
X-Cookie: Blow it out your ear.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 06:10:02PM +0530, Ashish Chavan wrote:

> I see, I was not aware of this norm. I just thought that not changing
> the subject line may help in identifying multiple submissions of the
> same patch.

No, that's what the human readable portion is for.

> BTW, should the version info be also dropped in case if we consider this
> as a new, independent patch? Because many of the version increments were
> just because of changes in other, earlier patches in the series.

Personally I find the versioning information a waste of time in the
first place, it just obscures more of the subject line in mail readers.
A patch is going to be considered on its merits no matter how many times
it's been sent before, having a version number is often just depressing
(as with those PMIC patches).
