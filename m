Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964841Ab0GPJc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 05:32:59 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43646 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936143Ab0GPJc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 05:32:58 -0400
Message-ID: <4C402746.6080309@canonical.com>
Date: Fri, 16 Jul 2010 10:32:54 +0100
From: Lee Jones <lee.jones@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Stop ARM boards crashing when CUPS is loaded -	2.6.35-rc5
References: <4C3C72C6.4000005@canonical.com> <20100715130214.4c9303b2.akpm@linux-foundation.org> <20100715200618.GA6773@n2100.arm.linux.org.uk> <4C40218A.4090806@canonical.com> <20100716092018.GB16995@n2100.arm.linux.org.uk>
In-Reply-To: <20100716092018.GB16995@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The best solution is probably for the parport code to go through a
> modernisation cycle like the serial code did, essentially using
> platform devices to pass the base addresses.  This would make the
> driver more portable, and eliminates this problem entirely (because
> platforms which don't have parports won't register the platform device(s)
> necessary for parport to even probe illegal addresses.)

This sounds brilliant - when are you going to start? </kidding>

In all seriousness, do you think anyone is likely to undertake this 
work anytime soon? I am seeing this problem in a distribution which 
is due for release in October. I have no problem implementing a config
change in the meantime, but as you say, a more _correct_ and portable
solution should be sought.



