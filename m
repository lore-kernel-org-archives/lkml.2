Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab2LCOHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:07:07 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:60322 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab2LCOHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:07:06 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 3 Dec 2012 15:06:45 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: yongjun_wei@trendmicro.com.cn, linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] firewire: net: remove unused variable in
 fwnet_receive_broadcast()
Message-ID: <20121203150645.23054225@stein>
In-Reply-To: <CAPgLHd87JfwfhHVyBSSsqCCay8=U5Szv1My-Dvtf93M+AtKAkQ@mail.gmail.com>
References: <CAPgLHd87JfwfhHVyBSSsqCCay8=U5Szv1My-Dvtf93M+AtKAkQ@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 03 Wei Yongjun wrote:
> The variable card is initialized but never used
> otherwise, so remove the unused variable.

Committed to linux1394.git.
-- 
Stefan Richter
-=====-===-- ==-- ---==
http://arcgraph.de/sr/
