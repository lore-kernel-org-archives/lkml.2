Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab2BGX21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 18:28:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab2BGX20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 18:28:26 -0500
Date: Tue, 7 Feb 2012 15:28:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: rtc-linux@googlegroups.com
Cc: Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        Ivan Kuten <ivan.kuten@promwad.com>
Subject: Re: [rtc-linux] [PATCH] RTC: Add driver for NXP PCF8523 RTC chip
Message-Id: <20120207152815.6311c59a.akpm@linux-foundation.org>
In-Reply-To: <1317815823-27297-1-git-send-email-yauhen.kharuzhy@promwad.com>
References: <1317815823-27297-1-git-send-email-yauhen.kharuzhy@promwad.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Oct 2011 14:57:03 +0300
Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com> wrote:

> This driver is based on PCF8563 driver and supports only base functions
> now: read/write date & time.

This patch breaks my x86_64 allmodconfig build.

drivers/rtc/rtc-pcf8523.c: In function 'pcf8523_get_datetime':
drivers/rtc/rtc-pcf8523.c:55: warning: unused variable 'pcf8523'
drivers/rtc/rtc-pcf8523.c: In function 'pcf8523_set_datetime':
drivers/rtc/rtc-pcf8523.c:110: warning: unused variable 'pcf8523'
drivers/rtc/rtc-pcf8523.c: In function 'pcf8523_probe':
drivers/rtc/rtc-pcf8523.c:179: error: invalid application of 'sizeof' to incomplete type 'struct pcf8523' 
drivers/rtc/rtc-pcf8523.c:187: error: dereferencing pointer to incomplete type
drivers/rtc/rtc-pcf8523.c:188: error: 'THIS_MODULE' undeclared (first use in this function)
drivers/rtc/rtc-pcf8523.c:188: error: (Each undeclared identifier is reported only once
drivers/rtc/rtc-pcf8523.c:188: error: for each function it appears in.)
drivers/rtc/rtc-pcf8523.c:190: error: dereferencing pointer to incomplete type
drivers/rtc/rtc-pcf8523.c:191: error: dereferencing pointer to incomplete type
drivers/rtc/rtc-pcf8523.c: In function 'pcf8523_remove':
drivers/rtc/rtc-pcf8523.c:207: error: dereferencing pointer to incomplete type
drivers/rtc/rtc-pcf8523.c:208: error: dereferencing pointer to incomplete type
drivers/rtc/rtc-pcf8523.c: At top level:
drivers/rtc/rtc-pcf8523.c:219: warning: data definition has no type or storage class
drivers/rtc/rtc-pcf8523.c:219: warning: type defaults to 'int' in declaration of 'MODULE_DEVICE_TABLE'
drivers/rtc/rtc-pcf8523.c:219: warning: parameter names (without types) in function declaration
drivers/rtc/rtc-pcf8523.c: In function 'pcf8523_init':
drivers/rtc/rtc-pcf8523.c:232: error: 'THIS_MODULE' undeclared (first use in this function)
drivers/rtc/rtc-pcf8523.c: At top level:
drivers/rtc/rtc-pcf8523.c:240: error: expected declaration specifiers or '...' before string constant
drivers/rtc/rtc-pcf8523.c:240: warning: data definition has no type or storage class
drivers/rtc/rtc-pcf8523.c:240: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/rtc/rtc-pcf8523.c:240: warning: function declaration isn't a prototype
drivers/rtc/rtc-pcf8523.c:241: error: expected declaration specifiers or '...' before string constant
drivers/rtc/rtc-pcf8523.c:241: warning: data definition has no type or storage class
drivers/rtc/rtc-pcf8523.c:241: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/rtc/rtc-pcf8523.c:241: warning: function declaration isn't a prototype
drivers/rtc/rtc-pcf8523.c:242: error: expected declaration specifiers or '...' before string constant
drivers/rtc/rtc-pcf8523.c:242: warning: data definition has no type or storage class
drivers/rtc/rtc-pcf8523.c:242: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/rtc/rtc-pcf8523.c:242: warning: function declaration isn't a prototype
drivers/rtc/rtc-pcf8523.c:243: error: expected declaration specifiers or '...' before string constant
drivers/rtc/rtc-pcf8523.c:243: warning: data definition has no type or storage class
drivers/rtc/rtc-pcf8523.c:243: warning: type defaults to 'int' in declaration of 'MODULE_VERSION'
drivers/rtc/rtc-pcf8523.c:243: warning: function declaration isn't a prototype

