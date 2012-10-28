Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab2J1MJq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 08:09:46 -0400
Received: from smtp.domeneshop.no ([194.63.252.54]:48209 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab2J1MJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 08:09:45 -0400
Message-ID: <508D209D.8060003@paradoxuncreated.com>
Date: Sun, 28 Oct 2012 13:10:05 +0100
From: Ove Karlsen <ove.karlsen@paradoxuncreated.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Compilation options (for low jitter)
References: <508D1EBE.5070601@paradoxuncreated.com>
In-Reply-To: <508D1EBE.5070601@paradoxuncreated.com>
X-Forwarded-Message-Id: <508D1EBE.5070601@paradoxuncreated.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today I actually switched to Thunderbird.

Anyway disabling no_sse2 was a bad idea, increasing jitter/overhead.
Some optimizations for low-jitter such as no_defer and prefech latency
can change percieved latency/jitter slighty. 
http://paradoxuncreated.com/Blog/wordpress/?p=4223

And I am always interested in more information on that.

Currently I am using "-O3 -fno-defer-pop --param prefetch-latency=100"




