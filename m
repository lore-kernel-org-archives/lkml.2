Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836Ab0J1C6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 22:58:03 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55301 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744Ab0J1C6B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 22:58:01 -0400
MIME-Version: 1.0
In-Reply-To: <20101028095258.c778a223.kamezawa.hiroyu@jp.fujitsu.com>
References: <AANLkTimCSGoeRHXWS2Y5=THbOkHUfY71=B6JzOeFz_=X@mail.gmail.com>
	<20101028095258.c778a223.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 27 Oct 2010 19:58:00 -0700
Message-ID: <AANLkTikRCiX3dY3-iSXKX8YhQUZp=qoM7wm0cFnxq8NP@mail.gmail.com>
Subject: Re: Tweaking swap algorithm under constrained memory usage
From: Pawan Singh <pawan@pinger.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Recent kernel (2.6.28-) has splited LRUs as
>  - active/inactive ANON
>  - active/inactive FILE
>  - LOCKED (UNEVICTABLE) ---(new)

Thanks for the reply. Does that mean that in 2.6.28 kernel, kswapd
will modify its thresholds so that it only looks at active/inactive
ANON?

Thanks
Pawan
