Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab1AFQEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 11:04:54 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37406 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab1AFQEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 11:04:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=TPTNLu71jSy611p1x8lgzLxgdCvuCvy5eICBLvnhSyml0AarFsIlepBSz+gQb1MSbQ
         4q2SoDgrwKZtP187yUEOe/nZ+IWgCIezMc0Y41ypSKm6HxT6iSZ9oat0uz0dbaKcbV2Y
         uZdVYQv7PhDGWU0FBU2Lm5/3xAf8TAFuKxhRs=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] leds/h1940: Use gpiolib for latch access / fix build failure
Date: Thu, 6 Jan 2011 18:03:25 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r3-anarsoul; KDE/4.5.4; i686; ; )
Cc: Peter Huewe <peterhuewe@gmx.de>, Ben Dooks <ben-linux@fluff.org>,
        Vincent Sanders <support@simtec.co.uk>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
References: <1291932292-16049-1-git-send-email-peterhuewe@gmx.de> <201012100016.58130.anarsoul@gmail.com> <20110104153725.2f3fede2.akpm@linux-foundation.org>
In-Reply-To: <20110104153725.2f3fede2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101061803.26194.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 January 2011 01:37:25 Andrew Morton wrote:

> So which patch to use?
> 
> I queued Peter's patch because it's simpler.  I queued it for
> 2.6.38-rc1, taged for backporting into 2.6.37.x, so we have a bit of
> time to think about it.

Anyway, it's time to drop leds-h1940 driver, I'll submit patch to support 
H1940 leds via generic leds-gpio driver tonight.

Regards
Vasily
