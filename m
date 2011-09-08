Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726Ab1IHM4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:56:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60169 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932642Ab1IHM4G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:56:06 -0400
Subject: Re: Tasks schedule/migration issue with CPU hotplug?
From: Peter Zijlstra <peterz@infradead.org>
To: TAO HU <tghk48@motorola.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-omap <linux-omap@vger.kernel.org>,
        "yong.zhang0" <yong.zhang0@gmail.com>
Date: Thu, 08 Sep 2011 14:55:48 +0200
In-Reply-To: <CAOwKts8pXt6spknNfBV-wy4_KoSp-JaZsdbzOxxWTqu=f6X3Bg@mail.gmail.com>
References: <CAOwKts_WTDBLkz9=0MBhs6wzc67XD_bYgGMiZ-JUM+8O7gP_fw@mail.gmail.com>
	 <CAOwKts8pXt6spknNfBV-wy4_KoSp-JaZsdbzOxxWTqu=f6X3Bg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315486548.20256.4.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-08 at 14:47 +0800, TAO HU wrote:
> > We seems got a schedule/migration issue in a OMAP4430 dual-core system.
> > The kernel base is 2.6.35.7 and we're using CFS.

step 1, try with a kernel that isn't quite as fossilized 
	(3.0 or even better 3.1-rc)
step 2, if no luck, report that
step 3, when sending email, 
     3a, don't wrap machine output
     3b, include .config like things


