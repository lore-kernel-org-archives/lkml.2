Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab1KULF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 06:05:57 -0500
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:3835 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755981Ab1KULFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 06:05:55 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host pALB5pSE029126
Subject: Re: Running Application Inside Application
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Xin Tong <xerox.time.tech@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 21 Nov 2011 12:05:51 +0100
In-Reply-To: <CAM_iQpXPTheJU_+GKHkDu2b0WrV_4oJJbM+pWY3uprh6fX7cSw@mail.gmail.com>
References: <CALKntY135akw4khsrbVdk2L-YgF0aYsaHw6Lhf7n4gU6MTrZuQ@mail.gmail.com>
	 <CAM_iQpXPTheJU_+GKHkDu2b0WrV_4oJJbM+pWY3uprh6fX7cSw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1321873552.22548.63.camel@thorin>
Mime-Version: 1.0
X-DCC-wuwien-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 11:25 +0800, Cong Wang wrote:
> On Mon, Nov 21, 2011 at 10:18 AM, Xin Tong <xerox.time.tech@gmail.com> wrote:
> > I have applications that do not install signal handlers I need it to
> > install. Therefore, I am thinking about having a light-weight run-time
> > to load the application ELF file and install the needed signal handler
> > in the run-time ? Is this doable ? What if it is not ELF-encoded ?
> 
> If you want to exec*() to load the ELF, no, the signal handlers will be

It is in general so - not only für ELF.

> cleared after exec*(), as the entire .text will be replaced by the new ELF file.
> 
> So, you probably have to parse and load the ELF file by yourself.

Hmmm, if these (obviously broken) applications use dynamic linking, one
could probably use a preload library.
Never tried that though .....

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

