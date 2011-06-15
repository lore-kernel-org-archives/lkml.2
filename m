Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab1FOAyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 20:54:46 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:32911 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab1FOAyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 20:54:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF802CA.2030207@jp.fujitsu.com>
Date: Wed, 15 Jun 2011 09:54:34 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: cfowler@opsdc.com
CC: cfowler@outpostsentinel.com, linux-kernel@vger.kernel.org
Subject: Re: Panic on OOM
References: <1308058276.2074.295.camel@compaq-desktop>
In-Reply-To: <1308058276.2074.295.camel@compaq-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

(2011/06/14 22:31), Chris Fowler wrote:
> I'm running into a problem in 2.6.38 where the kernel is not doing what
> I'm expecting it to do.  I'm guessing that some things have changed and
> that is what it going on.

If guess, you need kernel upgrade. Maybe you need following commit.


	Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
	Date:   Thu Apr 14 15:22:12 2011 -0700

	    vmscan: all_unreclaimable() use zone->all_unreclaimable as a name

And

 % git name-rev --tags 929bea7c714220fc76ce3f75bef9056477c28e74
929bea7c714220fc76ce3f75bef9056477c28e74 tags/v2.6.39-rc4~36



