Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2EMPPN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 11:15:13 -0400
Received: from mail.agmk.net ([91.192.224.71]:40876 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab2EMPPL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 11:15:11 -0400
From: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@pld-linux.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Subject: Re: Linux-3.4-rc7
Date: Sun, 13 May 2012 17:15:04 +0200
Message-ID: <1968221.ZfIukAANIQ@localhost>
User-Agent: KMail/4.8.3 (Linux/3.3.5-1; KDE/4.8.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i've found one more issue in install log:

(...)
  DEPMOD  3.4.0-rc7
WARNING: /lib/modules/3.4.0-rc7/kernel/drivers/net/macvlan.ko needs unknown symbol skb_set_dev
WARNING: /lib/modules/3.4.0-rc7/kernel/net/8021q/8021q.ko needs unknown symbol skb_set_dev
(...)

BR,
Paweł.

