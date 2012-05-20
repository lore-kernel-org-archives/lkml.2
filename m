Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab2ETV1A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 17:27:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44224 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab2ETV06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 17:26:58 -0400
Date: Sun, 20 May 2012 14:26:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Nasir Abed <nasirabed@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        swetland@google.com, Nasir Abed <nasirabed+kernel@gmail.com>
Subject: Re: [PATCH] Staging: android: alarm: Rename pr_alarm to alarm_dbg
In-Reply-To: <1337547996.31503.8.camel@joe2Laptop>
Message-ID: <alpine.DEB.2.00.1205201426430.10189@chino.kir.corp.google.com>
References: <1337507659-14740-1-git-send-email-nasirabed+kernel@gmail.com> <alpine.DEB.2.00.1205201328170.10189@chino.kir.corp.google.com> <1337546284.31503.5.camel@joe2Laptop> <1337547996.31503.8.camel@joe2Laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2012, Joe Perches wrote:

> Rename a macro to make it explicit it's for debugging.
> 
> Use %s: __func__ instead of embedding function names.
> Coalesce formats, align arguments.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: David Rientjes <rientjes@google.com>
