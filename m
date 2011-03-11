Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab1CKRnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 12:43:51 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:48864 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab1CKRnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 12:43:50 -0500
Date: Fri, 11 Mar 2011 09:43:22 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org, Riku Voipio <riku.voipio@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2011-03-10-16-42 uploaded (leds/leds-pca9532.c)
Message-Id: <20110311094322.9096e9df.randy.dunlap@oracle.com>
In-Reply-To: <201103110118.p2B1I0CD007975@imap1.linux-foundation.org>
References: <201103110118.p2B1I0CD007975@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D7A5F4A.0020,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011 16:43:04 -0800 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2011-03-10-16-42 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git


When GPIOLIB is not enabled:

drivers/leds/leds-pca9532.c:39: error: field 'gpio' has incomplete type

config LEDS_PCA9532
	tristate "LED driver for PCA9532 dimmer"
	depends on LEDS_CLASS
	depends on I2C && INPUT && EXPERIMENTAL

Should this also depend on GPIOLIB?

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
