Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab1FHPZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 11:25:52 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:33764 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754910Ab1FHPZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 11:25:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=I1mT/R3RzlF+ikllGOqaCYPJTh2g/LrLiH9cL8IT1YsDPtv4uEo+ZUU6kF0+W+GaYoNZTb/NoJk2BFv3tKUBMck9jQsli+K0etjk8nznYrw/Gj8ndDUeCT4L0BhQs9Tj;
Date: Wed, 8 Jun 2011 08:25:48 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: wangyanqing <udknight@gmail.com>
Cc: namhyung@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: doc?
Message-Id: <20110608082548.8ab682fd.rdunlap@xenotime.net>
In-Reply-To: <20110608104057.GA11680@ahead>
References: <20110608104057.GA11680@ahead>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jun 2011 10:40:58 +0000 wangyanqing wrote:

> Hello, all!
> Today when I look into dumpstack of x86,
> I get %pB format specifier, and I don't
> know what it is. But I can't find the information
> from Documentation/printk-formats.txt. Yes, I
> get the introduce from "git annotate and git log",
> but I thinks It will be better if patches authors will 
> add some documentation, right?
> --

It wouldn't hurt to add some docs, yes, but for now the %p
extensions are all documented in lib/vsprintf.c, just above
function pointer(), around line 802 in 3.0-rc2.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
