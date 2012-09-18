Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab2IRFiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 01:38:08 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:36330 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754221Ab2IRFiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 01:38:07 -0400
Message-ID: <505808B8.7070100@ti.com>
Date: Tue, 18 Sep 2012 11:08:00 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Ryan Mallon <rmallon@gmail.com>
CC: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH 3/7] rtc: Convert struct i2c_msg initialization to C99
 format
References: <1347890294-28467-1-git-send-email-shubhrajyoti@ti.com> <1347890294-28467-4-git-send-email-shubhrajyoti@ti.com> <5057D22E.8080202@gmail.com>
In-Reply-To: <5057D22E.8080202@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2012 07:15 AM, Ryan Mallon wrote:
>>  		,
> Putting the whole initialiser on one line is a bit ugly. Any reason not
> to expand it over multiple lines as the previous patch (and majority of
> other drivers) does?
Will do that.

