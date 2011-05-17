Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab1EQIm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:42:26 -0400
Received: from smtp.nokia.com ([147.243.1.47]:58531 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab1EQImZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:42:25 -0400
Subject: Re: [RFC PATCHv4 0/7] HSI framework and drivers
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Linus Walleij <linus.walleij@linaro.org>
Cc: Govindraj <govindraj.ti@gmail.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        pawel.szyszuk@stericsson.com
In-Reply-To: <BANLkTikrXb7h_iG+xOvFPozT6w5Nj8nJKw@mail.gmail.com>
References: <1292321383-30200-1-git-send-email-carlos.chinea@nokia.com>
	 <AANLkTimTfOyhDR6BsHD_1VvzOPGbYqo6L784wPkQMi_8@mail.gmail.com>
	 <1300787404.8008.116.camel@groo>
	 <BANLkTincpt8ojK8icvXz4XfkWL9z87VmUA@mail.gmail.com>
	 <BANLkTikrXb7h_iG+xOvFPozT6w5Nj8nJKw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 11:39:13 +0300
Message-ID: <1305621553.24348.5009.camel@groo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 14:04 +0200, ext Linus Walleij wrote:
> On Thu, May 12, 2011 at 2:17 PM, Govindraj <govindraj.ti@gmail.com> wrote:
> > On Tue, Mar 22, 2011 at 3:20 PM, Carlos Chinea <carlos.chinea@nokia.com> wrote:
> >> Hi,
> >>
> >> On Mon, 2011-03-21 at 09:16 +0100, ext Linus Walleij wrote:
> >>> 2010/12/14 Carlos Chinea <carlos.chinea@nokia.com>:
> >>>
> >>> > Here you have the fourth round of the HSI framework patches.
> >>>
> >>> I'd like to notify that this out-of-tree framework is also in use for
> >>> the ST-Ericsson
> >>> Ux500s, and we've had great success with it. You can add my:
> >>>
> >>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> >>>
> >>
> >
> > Hi Carlos,
> >
> > Will you posting a next version of HSI framework.
> >
> > I am planning to adapt omap-hsi driver to this framework.
> 
> I was sort of asking the same thing.

> I expected this to be queued up for 2.6.40 so we don't proliferate
> out-of-tree drivers :-(
> 
> If Nokia will not pursue this patch set then tell me and Govindraj
> and we can surely take it over.
> 

We are still committed to these patches. We are aiming to release a new
version in 3 weeks max, sooner if we can.

I am very sorry for the delay and I agree that starting to have several
out-of-tree drivers is not acceptable. I'll try my best to fix this
asap.

Br,
-- 
Carlos Chinea <carlos.chinea@nokia.com>

