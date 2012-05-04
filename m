Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab2EDOnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 10:43:04 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:29689 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2EDOnB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 10:43:01 -0400
Message-ID: <4FA3EAEE.9030601@wanadoo.fr>
Date: Fri, 04 May 2012 16:42:54 +0200
From: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: Re: RCU related performance regression in 3.3
References: <20177034.34764.1335528920975.JavaMail.www@wwinf1f04> <20120428034257.GA2495@linux.vnet.ibm.com> <20120501000245.GA4329@linux.vnet.ibm.com> <4F9FA50C.9070600@wanadoo.fr> <20120501154513.GD2441@linux.vnet.ibm.com>
In-Reply-To: <20120501154513.GD2441@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 01/05/2012 17:45, Paul E. McKenney a écrit :

> Here is my RCU_FAST_NO_HZ patch stack on top of v3.4-rc4.
>
> Or you can pull branch fnh.2012.05.01a from:
>
> 	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
>
> 							Thanx, Paul
>
I applied your global patch on top of v3.4-rc4. But the slowdown is
worse than before : boot sequence took 80s instead 20-30s (12s for
initramfs instead of 2s).

I'll send you rcu tracing log in a second mail.

Pascal

