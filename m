Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab1CNUg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:36:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51647 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab1CNUg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:36:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] Add STMicroelectronics LPS001WP pressure sensor device driver into misc
Date: Mon, 14 Mar 2011 21:36:43 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.5.1; x86_64; ; )
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        mems applications <mems.applications@st.com>, rdunlap@xenotime.net,
        carmine.iascone@st.com, matteo.dameno@st.com, rubini@cvml.unipv.it,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
References: <1300128906-1066-1-git-send-email-matteo.dameno@st.com> <4D7E771B.1040804@cam.ac.uk> <20110314211809.29da8518@endymion.delvare>
In-Reply-To: <20110314211809.29da8518@endymion.delvare>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103142136.43566.arnd@arndb.de>
X-Provags-ID: V02:K0:HaLIu8RdjOQpr7wpPAuIkGTWe6tof3jLmTtsahgTbUR
 I3z/Kyh9+zv7WCFgE6Bkf59yX6GrN+2tOkJAcuUSGRRwwNBfV8
 eIqk6XDsUoKtT2j1HHsT6A6oV5pQURFhZyapLcuqL1GyJcGjzf
 DhdwbZRoB9m/JWLiTZaJkDX1CwX+cBB5paxHxYgyzHTO5zN0Vo
 OevLFpsI9ejV4DX0bgBIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 March 2011 21:18:09 Jean Delvare wrote:
> Jonathan is correct. Pressure sensors are not hardware monitoring
> devices, their drivers have nothing to do in drivers/hwmon. This is
> something for drivers/misc or staging/iio.

I generally try to prevent people from adding more ad-hoc interfaces
to drivers/misc. Anything that is called a drivers/misc driver to me
must qualify as "there can't possibly be a second driver with the
same semantics", otherwise it should be part of another subsystem
with clear rules, or be put into its own file system.

While it seems that right now everyone is just trying to keep move
the driver to some other subsystem, I think it's worth noting that
it is indeed a useful thing to have the driver, I'm optimistic
that we can find some place for it. ;-)

Now how about the IIO stuff? This is the first time I've even
heard about it. Does it have any major disadvantages besides
being staging-quality?

	Arnd
