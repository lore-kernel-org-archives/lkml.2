Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1L0JNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 04:13:35 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43308 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab1L0JN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 04:13:28 -0500
Message-ID: <1324977203.28904.1.camel@lappy>
Subject: Re: INFO: task rcuc/0:7 blocked for more than 120 seconds.
From: Sasha Levin <levinsasha928@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 27 Dec 2011 11:13:23 +0200
In-Reply-To: <20111226163148.GC2435@linux.vnet.ibm.com>
References: <1324901803.31721.4.camel@lappy>
	 <20111226163148.GC2435@linux.vnet.ibm.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-26 at 08:31 -0800, Paul E. McKenney wrote:
> Except that when I try looking for task_notify_func() in current mainline,
> I get nothing.
> 
> Where is task_notify_func() coming from? 

I was testing linux-next, it actually comes from the android tree:
drivers/staging/android/lowmemorykiller.c

-- 

Sasha.

