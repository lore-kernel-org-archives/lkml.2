Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab1JDOrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 10:47:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53812 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab1JDOrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 10:47:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 22/30] mfd: build twl6030 only on omap2
Date: Tue, 4 Oct 2011 16:47:02 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Balaji T K <balajitk@ti.com>,
        Hemanth V <hemanthv@ti.com>, Bill Gatliff <bgat@billgatliff.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-23-git-send-email-arnd@arndb.de> <20111004104713.GY4118@sortiz-mobl>
In-Reply-To: <20111004104713.GY4118@sortiz-mobl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110041647.02690.arnd@arndb.de>
X-Provags-ID: V02:K0:ixAabZArD49QqVIf4WRFgXQD3ejQF5j9U9UguDzhmqe
 sbbIXsFGkaj6lQxI/UliPivMVD7m3vp+geq5ojf6Qoju4XpnaQ
 jlRs9blKXbQlBlYhoyyQMovckIjLoIszneEV8CD0rmHo6ucRWZ
 oEWOiqiHA8G7BS9ItrIZvCcPPm6WT8aXGmWVELevLphztgalA1
 T0ko4Nv6jBe0YPWRab4smEPwIkuGY98G4U15KElO/+HTys/l7t
 o9oTZgGRcV3dzIxVG1nVTLE9sy4bwo3cFsX777uBqIzkv+Z1b7
 jMSmQgQllNRDB5du1xGBn9I0uf3nVntj+RUy14VDyX9bFBnMFO
 8Its+EFHkA6LJc6Fnmmc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 October 2011, Samuel Ortiz wrote:
> On Sun, Oct 02, 2011 at 04:45:52PM +0200, Arnd Bergmann wrote:
> > We can only have one pwm driver built into the kernel,
> I seem to remember that Bill Gatliff was working on a PWM subsystem that would
> get rid of the current pwm.h ugliness. Do we have any updates on this one ?

I don't know if the work on the pwm subsystem is progressing right now,
there were at one point two competing patches, but so far neither of them
has made it into linux-next.
 
> The patch below looks like a hack to me, trying to work around the current
> lack of such subsystem.

Absolutely. I'll clarify this in the patch description when I fix the
bug pointed out by Balaji T Krishnamoorthy.

	Arnd
