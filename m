Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab2KWMma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:42:30 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38451 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2KWMm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:42:26 -0500
Date: Fri, 23 Nov 2012 13:42:21 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Rickard Andersson <rickard.andersson@stericsson.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] cpufreq: ondemand: handle SW coordinated CPUs
Message-ID: <20121123124221.GA7378@balto.lan>
Mail-Followup-To: Fabio Baltieri <fabio.baltieri@linaro.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
	linux-pm@vger.kernel.org,
	Rickard Andersson <rickard.andersson@stericsson.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
References: <1353663117-10074-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353663117-10074-1-git-send-email-fabio.baltieri@linaro.org>
X-Operating-System: Linux balto 3.7.0-rc2-00232-g6b8294a x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Fri, Nov 23, 2012 at 10:31:56AM +0100, Fabio Baltieri wrote:
>  drivers/cpufreq/cpufreq_ondemand.c | 152 ++++++++++++++++++++++++++++++++-----
>  1 file changed, 132 insertions(+), 20 deletions(-)

I just noticed that the whole ondemand driver was refactored in your
linux-pm.git/linux-next branch so my patch does not apply.  I'm
preparing a rebased version of the set, so feel free to skip this one.

Thanks,
Fabio

-- 
Fabio Baltieri
