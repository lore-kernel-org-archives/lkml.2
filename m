Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab2DQQsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:48:53 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35387 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2DQQsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:48:51 -0400
Subject: Re: [PATCH] set fake_rtable's dst to NULL to avoid kernel Oops.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: "Peter Huang (Peng)" <peter.huangpeng@huawei.com>,
        "'David S. Miller'" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ctrix+debianbugs@navynet.it,
        peter.huangpeng@gmail.com, harry.majun@huawei.com
In-Reply-To: <20120417085248.3e642294@nehalam.linuxnetplumber.net>
References: <000001cd1c62$75d10de0$617329a0$%huangpeng@huawei.com>
	 <20120417085248.3e642294@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Apr 2012 18:48:43 +0200
Message-ID: <1334681323.2472.43.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-17 at 08:52 -0700, Stephen Hemminger wrote:

> This check seems like a disaster waiting to happen when the next
> change to DST table happens.

Please Peter Document this, adding a new DST_FAKE_RTABLE flag

#define DST_FAKE_RTABLE DST_NOPEER

or just use a bit, we have plenty of them available.


