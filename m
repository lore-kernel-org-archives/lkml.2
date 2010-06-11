Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952Ab0FKAKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 20:10:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50961 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab0FKAKf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 20:10:35 -0400
MIME-Version: 1.0
Date: Fri, 11 Jun 2010 02:10:33 +0200
Message-ID: <AANLkTil0M_2aiRX5IoMzC90O9WgzJPco3arHmDSG_44H@mail.gmail.com>
Subject: Hardcore trashing without any swap
From: =?UTF-8?B?TMOhc3psw7MgTW9uZGE=?= <laci@monda.hu>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi List,

The problem I'm facing with is very simple, yet extremely irritating
in nature.  I have a laptop with 4G RAM and I don't use any swap.
Whenever the RAM is full my system keeps trashing.  This makes X and
SSH completely unresponsive for about a hour then a bunch of processes
gets killed and it's usable again.

How is possible that my system is trashing even though I don't use any swap?

I'd expect the kernel to immediately kill the largest process without
any trashing so I could continue my work right after the event.  How
is it possible to configure?

laci@nitehawk:~$ uname -a
Linux nitehawk 2.6.31-20-generic #58-Ubuntu SMP Fri Mar 12 04:38:19
UTC 2010 x86_64 GNU/Linux

I'd gladly provide any more details but I'm not sure what is relevant
and I guess it's a pretty general problem so you're welcomed to ask
about any more information.

Thank you very much for your answer in advance!

PS: Please CC me because I'm not on the list.

-- 
László Monda <http://monda.hu>
