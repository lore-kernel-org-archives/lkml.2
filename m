Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab2IRMTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:19:42 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:53344 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756971Ab2IRMTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:19:40 -0400
Message-ID: <505866D5.6040807@ti.com>
Date: Tue, 18 Sep 2012 17:49:33 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: balbi@ti.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCHv3 5/6] media: Convert struct i2c_msg initialization to
 C99 format
References: <1347968672-10803-1-git-send-email-shubhrajyoti@ti.com> <1347968672-10803-6-git-send-email-shubhrajyoti@ti.com> <20120918114224.GH24047@arwen.pp.htv.fi>
In-Reply-To: <20120918114224.GH24047@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2012 05:12 PM, Felipe Balbi wrote:
> On Tue, Sep 18, 2012 at 05:14:31PM +0530, Shubhrajyoti D wrote:
>> >         Convert the struct i2c_msg initialization to C99 format. This makes
>> >         maintaining and editing the code simpler. Also helps once other fields
>> >         like transferred are added in future.
> no need for these tabs here.
yep will fix and repost thanks.

> FWIW:
>
> Reviewed-by: Felipe Balbi <balbi@ti.com>
thanks for the review


