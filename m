Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab1FHHQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 03:16:45 -0400
Received: from smtp.nokia.com ([147.243.1.48]:24449 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab1FHHQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 03:16:43 -0400
Subject: Re: [RFC PATCHv4 0/7] HSI framework and drivers
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Sebastian Reichel <sre@debian.org>
Cc: ext Linus Walleij <linus.walleij@linaro.org>,
        Govindraj <govindraj.ti@gmail.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        pawel.szyszuk@stericsson.com
In-Reply-To: <20110607150910.GA3780@earth.universe>
References: <1292321383-30200-1-git-send-email-carlos.chinea@nokia.com>
	 <AANLkTimTfOyhDR6BsHD_1VvzOPGbYqo6L784wPkQMi_8@mail.gmail.com>
	 <1300787404.8008.116.camel@groo>
	 <BANLkTincpt8ojK8icvXz4XfkWL9z87VmUA@mail.gmail.com>
	 <BANLkTikrXb7h_iG+xOvFPozT6w5Nj8nJKw@mail.gmail.com>
	 <1305621553.24348.5009.camel@groo>  <20110607150910.GA3780@earth.universe>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 10:12:45 +0300
Message-ID: <1307517165.2819.33110.camel@groo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2011-06-07 at 17:09 +0200, ext Sebastian Reichel wrote:
> On Tue, May 17, 2011 at 11:39:13AM +0300, Carlos Chinea wrote:
> > We are still committed to these patches. We are aiming to release a new
> > version in 3 weeks max, sooner if we can.
> > 
> > I am very sorry for the delay and I agree that starting to have several
> > out-of-tree drivers is not acceptable. I'll try my best to fix this
> > asap.
> 
> Do you also plan to add the platform code for rx51 to the mainline
> kernel?

Not yet in this patch set. If the HSI framework makes it into the
kernel, then I will try to push a couple of new HSI clients needed for
rx51 and the platform related code.

> 
> P.S.: 3 weeks are over today :)
> 

Yep, we are almost there with the patches :P A small problem in a last
minute test is keeping us from releasing the patches already.

Br,
-- 
Carlos Chinea <carlos.chinea@nokia.com>

