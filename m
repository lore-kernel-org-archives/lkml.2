Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab0EJExB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 00:53:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:53285 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab0EJEw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 00:52:57 -0400
Date: Mon, 10 May 2010 12:52:52 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: May the worker function free its struct_work (plus container)?
Message-ID: <20100510045252.GC3387@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <AANLkTikTPkLID3e8HpT1jMeiF9tQ6-7oJWQBfiRF7xUN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTikTPkLID3e8HpT1jMeiF9tQ6-7oJWQBfiRF7xUN@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 May 2010 04:52:55.0522 (UTC) FILETIME=[A78B9420:01CAEFFC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 12:47:23AM +0200, Leon Woestenberg wrote:
> Hello,
> 
> may the worker function kfree() it's own work data structure?

Actually, workqueue has no restriction on this kind of operation.
But if you must be careful with the caller in case it will refer
the freed struct.

Thanks,
Yong
