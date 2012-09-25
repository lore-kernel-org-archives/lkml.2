Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab2IYLUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:20:01 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:53049 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755237Ab2IYLTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:19:52 -0400
Message-ID: <50619352.5050105@ti.com>
Date: Tue, 25 Sep 2012 16:49:46 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: balbi@ti.com
CC: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, a.zummo@towertech.it
Subject: Re: [PATCHv2 1/7] rtc: Convert struct i2c_msg initialization to C99
 format
References: <1348569224-4096-1-git-send-email-shubhrajyoti@ti.com> <1348569224-4096-2-git-send-email-shubhrajyoti@ti.com> <20120925105504.GQ9137@arwen.pp.htv.fi>
In-Reply-To: <20120925105504.GQ9137@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 September 2012 04:25 PM, Felipe Balbi wrote:
>> +			.buf = &addr
>> > +		},
>> > +		{/* setup read ptr */
> should this comment be /* read date */ ??
yes missed that . will update
