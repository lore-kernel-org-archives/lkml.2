Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab0KAWAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 18:00:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19750 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab0KAWAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 18:00:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qVew6XN/luaQ1+KJrIjpeUa8GAK4/IUgg50jVVmaV9BI5EFh7EhIms3nL1sS8ceQfv
         JQJIW/6ECv2QrcUbg6tw==
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1010302333130.1572@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010302333130.1572@swampdragon.chaosbits.net>
Date: Mon, 1 Nov 2010 15:00:14 -0700
Message-ID: <AANLkTi=3mnPWpBB_jehkM6OCyjDwzdwxvyQW9tLQQTC6@mail.gmail.com>
Subject: Re: [PATCH] cgroup: Avoid a memset by using vzalloc
From: Paul Menage <menage@google.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 2:35 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> Hi,
>
> We can avoid doing a memset in swap_cgroup_swapon() by using vzalloc().
>
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: Paul Menage <menage@google.com>
