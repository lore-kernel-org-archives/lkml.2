Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0HZOtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 10:49:46 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:40153 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab0HZOtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 10:49:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ILuPblTrkuT6zk7OH2qSiAkbyvWZeSV7a2zUQU+F/FRzupBa3A9fUY8acWPyCl8QT9
         GNSNs3zTqq0uI5CWyWoqdhRH+S0NT5E5DQNb4nMiq/vSSt4jzEWVVORIA02D6OCniuHq
         lgTo5F9riQSe+XVyVW4+VExh2r/zXHmdzlb9w=
Date: Thu, 26 Aug 2010 07:49:37 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Neil Leeder <nleeder@codeaurora.org>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Horace Fu <horace.fu@quantatw.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Trilok Soni <tsoni@codeaurora.org>
Subject: Re: [PATCH v2] input: mouse: add qci touchpad driver
Message-ID: <20100826144937.GA8553@core.coreip.homeip.net>
References: <1281631760-15589-1-git-send-email-nleeder@codeaurora.org>
 <20100813024912.GA2661@core.coreip.homeip.net>
 <4C65BF99.9030601@codeaurora.org>
 <201008131754.49488.dmitry.torokhov@gmail.com>
 <4C6AC393.8000109@codeaurora.org>
 <BC741E3E-377E-45BF-80E1-A60F4E0FDFC9@gmail.com>
 <4C6C52DE.4040700@codeaurora.org>
 <20100819053311.GE5832@core.coreip.homeip.net>
 <4C6DADDE.7030107@codeaurora.org>
 <4C756049.2090408@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C756049.2090408@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On Wed, Aug 25, 2010 at 02:26:17PM -0400, Neil Leeder wrote:
> 
> Any comment on the above alternatives?
> 
> A third suggestion might be to have a fairly general serio driver,
> and rewrite the original Quanta driver to use serio rather than
> using i2c directly. I think that has its own set of problems, but
> thought I'd mention it anyway. The nuvoTon EC doesn't present a
> fully-working and reliable PS/2 interface to the driver so I'd lean
> toward using the Quanta touchpad driver by itself.
> 

I concur that since EC firmware does not seem to support full PS/2
protocol we should got with the original driver creating an input device
rather than serio.

Please send me the latest version of your driver and I will apply it to
my .37 queue.

Thanks.

-- 
Dmitry
