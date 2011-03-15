Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab1CONbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 09:31:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55069 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836Ab1CONba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 09:31:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] Add STMicroelectronics LPS001WP pressure sensor device driver into misc
Date: Tue, 15 Mar 2011 14:31:21 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Jean Delvare <khali@linux-fr.org>,
        mems applications <mems.applications@st.com>, rdunlap@xenotime.net,
        carmine.iascone@st.com, matteo.dameno@st.com, rubini@cvml.unipv.it,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>, Greg KH <greg@kroah.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
References: <1300128906-1066-1-git-send-email-matteo.dameno@st.com> <4D7F4944.4070507@cam.ac.uk> <20110315125149.GC17277@sirena.org.uk>
In-Reply-To: <20110315125149.GC17277@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103151431.22052.arnd@arndb.de>
X-Provags-ID: V02:K0:5sDzYo8OE8KGIT+nT1wZHYqgGalEtGIrgkmJjNFPlQI
 fXWuY9eCbGE9NOPlABqaBmNkX0WM2Javv8R3NjjZR629zegqpG
 Rvg0JK3y/vyLgY3+0R73NGb4VGcyMHX5lNxckUoSxL93qPj5zy
 RQsS/uSVabnr0ACjB/hgz7ywp0eHfW6YSiHGcdikFGSbkz5vLx
 bdVzw8aDx02Wj8fvmmT4Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 March 2011, Mark Brown wrote:
> > 2) Basically make a copy.  This would look like the original patch set did when we went
> 
> A third option is just to lift everything out of staging roughly as it
> is now with anything that definitely needs redoing dropped, addressing
> any review comments for mainline but not doing much else, and then
> resume working on adding additional stuff.  It sounds like the userspace
> interfaces that are there at present are mostly OK and most of the
> issues are in-kernel?
> 
> You could perhaps have a Kconfig control for disabling any experimental
> features in the API if you want to give people hints about areas that
> are likely to churn.

I agree, that sounds like a good idea for preparing the code before a split.

	Arnd
