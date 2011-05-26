Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab1EZAIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 20:08:55 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:32921 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754504Ab1EZAIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 20:08:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Y7aX5MmZkBNVw+qHgt8pE4GAzz/PIAHiiv8iKVE3EaAlG/FszGrzV2CMvjCdVO1aWWags7QouJzm9xiTkuRX8L+J4RX+LIDZ3w9pFtlGltenWby6wjzRVkRXs734J6VL;
Date: Wed, 25 May 2011 17:08:52 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: build error in current git
Message-Id: <20110525170852.68c0d382.rdunlap@xenotime.net>
In-Reply-To: <BANLkTikNj7H3m1poPr+jU-O7znEXOst3jw@mail.gmail.com>
References: <BANLkTikNj7H3m1poPr+jU-O7znEXOst3jw@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011 03:04:52 +0300 Anca Emanuel wrote:

>   CC [M]  drivers/usb/serial/qcaux.o
> drivers/video/mb862xx/mb862xx-i2c.c: In function ‘mb862xx_i2c_wait_event’:
> drivers/video/mb862xx/mb862xx-i2c.c:25:3: error: implicit declaration
> of function ‘udelay’
> --

Andrew put a patch for this into his mm tree:
http://marc.info/?l=linux-mm-commits&m=130636492131543&w=2


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
