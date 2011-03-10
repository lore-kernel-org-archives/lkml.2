Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab1CJNqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 08:46:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41816 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752683Ab1CJNqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 08:46:08 -0500
Date: Thu, 10 Mar 2011 13:46:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Cai, Cliff" <Cliff.Cai@analog.com>
Cc: Cliff Cai <cliffcai.sh@gmail.com>, Mike Frysinger <vapier.adi@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Subject: Re: [alsa-devel] [Device-drivers-devel] [PATCH] Add driver for
 Analog Devices ADAU1701 SigmaDSP
Message-ID: <20110310134605.GC22195@opensource.wolfsonmicro.com>
References: <1299460302-15392-1-git-send-email-cliff.cai@analog.com>
 <20110307114142.GB13471@opensource.wolfsonmicro.com>
 <AANLkTikynw7vCsqqyNZW-LFuGUKKQEtG3s4YCZjpOvko@mail.gmail.com>
 <20110307121502.GG13471@opensource.wolfsonmicro.com>
 <AANLkTinKpvgBokSHpsVf1KVX+m6sD0Xp_dFe8Y+HzY-7@mail.gmail.com>
 <AANLkTik=wEyCEY5xsrdGJw6t_VHH9ByKt4mX348P8uD7@mail.gmail.com>
 <20110309100055.GB6923@opensource.wolfsonmicro.com>
 <DB904C5425BA6F4E8424B3B51A1414D16649F4A546@NWD2CMBX1.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB904C5425BA6F4E8424B3B51A1414D16649F4A546@NWD2CMBX1.ad.analog.com>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 04:45:48AM -0500, Cai, Cliff wrote:

> >If there is default firmware then even if it's not
> >particularly useful the kernel should probably not *require*
> >that additional firmware is provided during driver startup -

> I'm afraid it's not the real use case,the test mode just for test,
> In practice,people always want the DSP to run some algrithm at the beginning,
> Although they may change it later.

I'd be surprised if people wanted to actually play audio through a
passthrough firmware in a shipping system but consider cases like board
bringup (where just verifying that everything is physically connected is
useful) and early boot (where you might not have mounted all filesystems
yet but the driver is trying to start up).
