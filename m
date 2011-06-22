Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab1FVG24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 02:28:56 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:60331 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab1FVG2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 02:28:55 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: [PATCH v3] pch_gpio: Support interrupt function
Date: Wed, 22 Jun 2011 08:28:28 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
References: <1308631468-2376-1-git-send-email-tomoya-linux@dsn.okisemi.com> <201106211110.18171.alexander.stein@systec-electronic.com> <4E0132F4.7080506@dsn.okisemi.com>
In-Reply-To: <4E0132F4.7080506@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106220828.30516.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 June 2011 02:10:28 Tomoya MORINAGA wrote:
> (2011/06/21 18:10), Alexander Stein wrote:
> > I wrote a small program which use poll(2) on value, after edge hase been
> > configured from shell. I cannot test the edge detection appropriately due
> > to debouncing using jumpers.
> 
> Really ?
> In out test environment, my test program could detect edge interrupt
> correctly.

My test program used poll/select on edge successfully. But I could not test 
the raising or falling feature actually, as my input is bouncing. So, it 
doesn't matter if I set both/raising/falling in edge, due to my inputs the 
effect is the same. Any input event will end in several raising and falling 
interrupts events.
I hope I could make this more clear.

Alexander
