Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab2EJMxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 08:53:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44270 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab2EJMxb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 08:53:31 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20120405223231.GK817@titan.lakedaemon.net>
References: <1332804040.5294.2.camel@phoenix> <20120331011432.GG7274@titan.lakedaemon.net>
 <CAF+7xWkuZ6q1TbWpdvwK57wGBwd_naVZsvtj0UackWWFcam7qw@mail.gmail.com> <20120405223231.GK817@titan.lakedaemon.net>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 10 May 2012 20:53:10 +0800
Message-ID: <CAF+7xW=Z9kya92w6FxZri8miXQMSZYWMBwdSW47jpkQY+6YZ6A@mail.gmail.com>
Subject: Re: [PATCH RFT v3] watchdog: Convert orion_wdt driver to watchdog core
To: Jason Cooper <jason@lakedaemon.net>
Cc: linux-kernel@vger.kernel.org,
        Sylver Bruneau <sylver.bruneau@googlemail.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ah, much better.  I rebased it against v3.4-rc1 now that it's out.
> Compiles without problems.  I'll test this weekend most likely.  I don't
> have my watchdog code in front of me atm.
>
Hi Jason,
Does this patch work for you?

Thanks,
Axel
