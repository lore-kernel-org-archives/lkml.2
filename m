Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab2CEAkt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 19:40:49 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35224 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab2CEAks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 19:40:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of minggr@gmail.com designates 10.52.18.212 as permitted sender) smtp.mail=minggr@gmail.com; dkim=pass header.i=minggr@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAG-aW058YL042Q-Wkw3RpD_XmK3_Q+3uL1zmq6jX8iZTWfeX6Q@mail.gmail.com>
References: <CAG-aW058YL042Q-Wkw3RpD_XmK3_Q+3uL1zmq6jX8iZTWfeX6Q@mail.gmail.com>
Date: Mon, 5 Mar 2012 08:40:47 +0800
Message-ID: <CAF1ivSYB9cV6s6MRyB-w9peoGq=7Pgn5vjUc2YoDYtO8WGGatg@mail.gmail.com>
Subject: Re: eSATA hotplug (subsequent harddrives after disconnecting 1st one)
 not working with JMicron after transition from 3.2 to 3.3
From: Lin Ming <minggr@gmail.com>
To: Matt <jackdachef@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
        jeff@garzik.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 8:16 AM, Matt <jackdachef@gmail.com> wrote:
> Hi Linus,
>
> hi everyone!
>
>
> I'm going to make this short:
>
> nobody seems to have mentioned this issue:

Hi,

Could you have a try the patch at below link?

http://marc.info/?l=linux-kernel&m=132996405028746&w=2

Regards,
Lin Ming
