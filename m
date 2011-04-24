Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab1DXPdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 11:33:50 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65410 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463Ab1DXPdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 11:33:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=X6yu600GMwQ/pil4jM9Nb1YSm+IiLx5BGdB6cMzltI3aCv/LOamreOlXd8Yf6pnG4I
         gWRuCEp+G3r0w1CYeajKEvrAH3S/WXp0+g434cKhpTI2bdtXNPRyyr//kN6S/ympMqFi
         I1evp4Ni7fxud8t5lfYmjb1ZOlEAZtuKwzUQo=
MIME-Version: 1.0
In-Reply-To: <1303086002-6961-1-git-send-email-bookjovi@gmail.com>
References: <1303086002-6961-1-git-send-email-bookjovi@gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Mon, 25 Apr 2011 00:33:26 +0900
X-Google-Sender-Auth: ShToRBSwY5tWbx34_yl292Y-2P8
Message-ID: <BANLkTikh-_-dmxRzeCyFaWBcxc6qt8UQHw@mail.gmail.com>
Subject: Re: [PATCH] proc: put check_mem_permission before __get_free_page in mem_read
To: bookjovi@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/18  <bookjovi@gmail.com>:
> From: Jovi Zhang <bookjovi@gmail.com>
>
> It should be better if put check_mem_permission before __get_free_page
> in mem_read, to be same as function mem_write.
>
> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>

Looks good to me.
  Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
