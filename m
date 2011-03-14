Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab1CNL3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:29:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48433 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750990Ab1CNL33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:29:29 -0400
Date: Mon, 14 Mar 2011 11:29:47 +0000
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
Message-ID: <20110314112946.GA2626@opensource.wolfsonmicro.com>
References: <AANLkTikynw7vCsqqyNZW-LFuGUKKQEtG3s4YCZjpOvko@mail.gmail.com>
 <20110307121502.GG13471@opensource.wolfsonmicro.com>
 <AANLkTinKpvgBokSHpsVf1KVX+m6sD0Xp_dFe8Y+HzY-7@mail.gmail.com>
 <AANLkTik=wEyCEY5xsrdGJw6t_VHH9ByKt4mX348P8uD7@mail.gmail.com>
 <20110309100055.GB6923@opensource.wolfsonmicro.com>
 <DB904C5425BA6F4E8424B3B51A1414D16649F4A546@NWD2CMBX1.ad.analog.com>
 <20110310134605.GC22195@opensource.wolfsonmicro.com>
 <DB904C5425BA6F4E8424B3B51A1414D16649F4A8FB@NWD2CMBX1.ad.analog.com>
 <20110311115344.GA1760@opensource.wolfsonmicro.com>
 <DB904C5425BA6F4E8424B3B51A1414D16649F4AB9D@NWD2CMBX1.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB904C5425BA6F4E8424B3B51A1414D16649F4AB9D@NWD2CMBX1.ad.analog.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 10:23:19PM -0400, Cai, Cliff wrote:

> I think I need to have a check of the requirement from customer.
> Anyway,if I modified the driver according to the comments here,
> Would you like to accept it currently or we need to wait until the missing patch
> Has been merged in mainline?

Please repost, there were quite a few issues raised with this revision
even outside the firmware.  For the purpose of getting things into
mainline I'd recommend splitting out the functionaltiy which allows
firmware to be loaded dynamically at runtime as a second patch.
