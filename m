Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218Ab2GIEYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 00:24:55 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60652 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750814Ab2GIEYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 00:24:54 -0400
Message-ID: <1341807891.13174.40.camel@joe2Laptop>
Subject: Re: [PATCH 0/6] staging: vt6655: Cleanup in usage of macros
From: Joe Perches <joe@perches.com>
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Cc: gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com,
        jj@chaosbits.net, forest@alittletooquiet.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sun, 08 Jul 2012 21:24:51 -0700
In-Reply-To: <1341802286-28281-1-git-send-email-marcos.souza.org@gmail.com>
References: <1341802286-28281-1-git-send-email-marcos.souza.org@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-08 at 23:51 -0300, Marcos Paulo de Souza wrote:
> Hi kernel guys!
> 
> This patchset aims to clean all unused and commented macros.
> 
> For this challenge, forgotten-macros tool helped us.

Perhaps there may be false positives in your code.

Many times, macros like the below are used:

#define SUBSYSTEM_PREFIX_FOO	1
#define SUBSYSTEM_PREFIX_BAR	2
#define SUBSYSTEM_PREFIX_BAZ	3

#define USE_TYPE(type)	SUBSYSTEM_PREFIX_##type

It doesn't seem your code knows that style.

Also, the tool might be more flexible if it was
written using perl or python.


