Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab0EFGAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:00:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35330 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab0EFGAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:00:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4BE25AE8.1060607@s5r6.in-berlin.de>
Date: Thu, 06 May 2010 08:00:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Changli Gao <xiaosuo@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: indiscriminate get_maintainer.pl usage (was [PATCH] epoll: use wrapper
 functions)
References: <1273111054-10141-1-git-send-email-xiaosuo@gmail.com>
In-Reply-To: <1273111054-10141-1-git-send-email-xiaosuo@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc list shortened)

Changli Gao wrote:
>  fs/eventpoll.c       |    5 ++---
>  include/linux/wait.h |   15 +++++++++++++--
>  2 files changed, 15 insertions(+), 5 deletions(-)

$ git log fs/eventpoll.c include/linux/wait.h |grep stefanr
    Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Tested-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Please do not Cc me on subsystems that I do not develop nor maintain.
My personal inbox is full enough and my todo-list growing.
When I have time to look at patches to subsystems that I don't work with
normally, I look into my inbox.lkml.

If you rely on scripts/get_maintainer.pl, then please use it more
carefully or improve the script to produce more qualified Cc lists.

Thanks.
-- 
Stefan Richter
-=====-==-=- -=-= --==-
http://arcgraph.de/sr/
