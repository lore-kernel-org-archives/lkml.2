Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab0IEAnS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 20:43:18 -0400
Received: from xenotime.net ([72.52.115.56]:42835 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754431Ab0IEAnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 20:43:17 -0400
Date: Sat, 4 Sep 2010 17:43:08 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: runcoderen <runcoderzhcn@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ldd scull_load question
Message-Id: <20100904174308.409c070e.rdunlap@xenotime.net>
In-Reply-To: <1283646914.1741.3.camel@bencharluo-laptop>
References: <1283160040-6636-1-git-send-email-nab@linux-iscsi.org>
	<201009020156.53803.konrad@darnok.org>
	<1283455187.5598.86.camel@haakon2.linux-iscsi.org>
	<1283644390.556.74.camel@haakon2.linux-iscsi.org>
	<1283646914.1741.3.camel@bencharluo-laptop>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Sep 2010 08:35:14 +0800 runcoderen wrote:

> hi all:
> I am reading ldd(3rd).
> when I read the scull_load part.
> I can't understand some special sentences in the scripts as follows:
> 
> /sbin/insmod ./$module.ko $* || exit 1
> 
> why we add $* and || exit 1 after /sbin/insmod ./$module.ko?
> 
> can anyone help me to understand?

"$*" passes all parameters of the script to the module as module parameters.

"insmod module.ko || exit 1"

means "if insmod is successful (no error), then the command is finished,
otherwise exit with an error code of 1."

Does that help?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
