Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab0J3XeF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 19:34:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48821 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab0J3XeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 19:34:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wjpC+Clf4sVP5DtUTJ0jEh+TmKiKZGwnDhfRurywow0NrjMUskdI/MPGAm74JImjC/
         2uUrxa7DA/yDlUIrg+oD2hwAozqoCQ8mjLJww8NQYs4arc9acaQY2EYnideDlxt1bqNU
         Cb0w0Y7ojYhcIGyGyDRGlqMi3jP+jCIFuhqMY=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1010302333130.1572@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010302333130.1572@swampdragon.chaosbits.net>
Date: Sun, 31 Oct 2010 08:34:01 +0900
Message-ID: <AANLkTi=nMU3ezNFD8LKBhJxr6CmW6-qHY_Mo3HRt6Os0@mail.gmail.com>
Subject: Re: [PATCH] cgroup: Avoid a memset by using vzalloc
From: Minchan Kim <minchan.kim@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 6:35 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> Hi,
>
> We can avoid doing a memset in swap_cgroup_swapon() by using vzalloc().
>
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

There are so many placed need vzalloc.
Thanks, Jesper.



-- 
Kind regards,
Minchan Kim
