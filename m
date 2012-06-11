Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab2FKUhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 16:37:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53117 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab2FKUhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 16:37:53 -0400
Date: Mon, 11 Jun 2012 13:37:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: cl@linux.com, kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: fix protection column misplacing in /proc/zoneinfo
In-Reply-To: <4FD60127.1000805@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1206111336370.4552@chino.kir.corp.google.com>
References: <1339422650-9798-1-git-send-email-kosaki.motohiro@gmail.com> <alpine.DEB.2.00.1206110856180.31180@router.home> <4FD60127.1000805@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012, KOSAKI Motohiro wrote:

> > You are not worried about breaking something that may scan the zoneinfo
> > output with this change? Its been this way for 6 years and its likely that
> > tools expect the current layout.
> 
> I don't worry about this. Because of, /proc/zoneinfo is cray machine unfrinedly
> format and afaik no application uses it.
> 

We do, and I think it would be a shame to break anything parsing the way 
that this file has been written for the past several years for something 
as aesthetical as this.
