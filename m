Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761196Ab2FDXMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 19:12:13 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:43204 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761162Ab2FDXML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 19:12:11 -0400
Message-ID: <1338851529.16672.1.camel@lorien2>
Subject: Re: [PATCH v2 1/3] leds: add oneshot blink functions
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: shuahkhan@gmail.com, Bryan Wu <bryan.wu@canonical.com>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Date: Mon, 04 Jun 2012 17:12:09 -0600
In-Reply-To: <20120604213735.GA1858@gmail.com>
References: <1338074364-1829-1-git-send-email-fabio.baltieri@gmail.com>
	 <1338135226.2968.22.camel@lorien2> <20120531210800.GB2400@gmail.com>
	 <1338565180.2618.9.camel@lorien2> <20120604213735.GA1858@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Of course, I've made many tests with mixes of led_trigger_blink() and
> led_trigger_blink_oneshot() calls, and they seems to work samelessly.
Great.
> 
> If you think that the patch is good I'd like to consider that for
> integration, so I can repost a modified version of my can-trigger
> patch on the linux-can mailing list.

Sounds good to me.

-- Shuah


