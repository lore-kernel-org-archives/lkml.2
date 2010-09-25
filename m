Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab0IYKaj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 06:30:39 -0400
Received: from mail-ww0-f48.google.com ([74.125.82.48]:64341 "EHLO
	mail-ww0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab0IYKai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 06:30:38 -0400
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Sep 2010 06:30:37 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=BRVgA3EjRakZGG5b1xfnkwEehxuM4AaIF7KJnefx6P0svIV40XXmzw08F7973UqSFn
         cA4YZgStiMRb6L/K+XojIDisjCB2tq2n0bhMPBIDTg4rWjQSk/Pm59Kuc+6ffNc9x7/c
         b+tyHdUEkQo1KjP9La8cwno893g2s5brZlJD4=
Date: Sat, 25 Sep 2010 12:25:15 +0200
From: Paolo Ornati <ornati@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Vasily Khoruzhick <anarsoul@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        Venkatesh Pallipadi <venki@google.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Subject: Re: Interrupt latency on some 945GM platforms
Message-ID: <20100925122515.4f9a516e@gmail.com>
In-Reply-To: <20100924123901.243c85e1@jbarnes-desktop>
References: <201009132336.17310.anarsoul@gmail.com>
	<201009162142.10629.anarsoul@gmail.com>
	<alpine.LFD.2.00.1009162049450.2416@localhost6.localdomain6>
	<201009162306.59508.anarsoul@gmail.com>
	<20100924123901.243c85e1@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 12:39:01 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> Vasily and Paolo, do you both have Atom CPUs with hyperthreading
> enabled?

model name      : Intel(R) Core(TM)2 Duo CPU     T6570  @ 2.10GHz

-- 
	Paolo Ornati
	Linux 2.6.35.4 on x86_64
