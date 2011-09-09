Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab1IIOri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 10:47:38 -0400
Received: from static-76-160-165-106.dsl.cavtel.net ([76.160.165.106]:50127
	"EHLO static-76-160-165-106.dsl.cavtel.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753320Ab1IIOrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 10:47:37 -0400
Message-ID: <4E6A2708.4070004@metrics.net>
Date: Fri, 09 Sep 2011 10:47:36 -0400
From: Anthony DeRobertis <aderobertis@metrics.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Icedove/3.1.13
MIME-Version: 1.0
To: Linux-kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Hard lockup in 3.0.3 with Oracle & mdraid check
References: <4E6634B2.6030204@metrics.net> <20110907031327.GA8087@zhy>
In-Reply-To: <20110907031327.GA8087@zhy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It should be fixed in current kernel.
>
> tglx just sent an pull reqeust(scheduler fixes) in which
> blk_schedule_flush_plug() is separated from schedule()

I have been testing with tglx's scheduler fixes for a day and a half
now, and no further lockups. Previously, it crashed fairly quickly, so I
believe its fixed.

Thank you.
