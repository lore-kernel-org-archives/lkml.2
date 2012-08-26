Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab2HZPGr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 11:06:47 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:41951 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750754Ab2HZPGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 11:06:46 -0400
Message-ID: <503A3B7C.4040005@xenotime.net>
Date: Sun, 26 Aug 2012 08:06:36 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: James <bjlockie@lockie.ca>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ifdef only module
References: <50399D1A.9080000@lockie.ca>
In-Reply-To: <50399D1A.9080000@lockie.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2012 08:50 PM, James wrote:

> I want to only run code if a module is being built.
> 
> drivers/media/video/cx25840/cx25840-core.c: 394
> If it is built into kernel it causes a timeout because it relies on udev which is not initialized yet.
> The code is only needed to provide analog reception.
> --



#ifdef MODULE
<that code>
#endif


-- 
~Randy
