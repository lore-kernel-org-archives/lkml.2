Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab1EXW3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 18:29:21 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52717 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab1EXW3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 18:29:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UwgRyiISesx2MLGvydWm9yWt34PWw787JcvWHndFr4G5Yjhybp/9a3ZHiOULyu9rZt
         tDxFp8cjFXj/KIvIKO3U5vpO518YE3kHno6HWmOKapddVUhe7xo2kFvodVqKbor+T+r0
         lsfB90xcLLhRDCMjIbwKjb0PKRYb0ZC9fQTWA=
MIME-Version: 1.0
In-Reply-To: <20110524133414.GA11674@nb-core2.darkstar.lan>
References: <20110524133414.GA11674@nb-core2.darkstar.lan>
Date: Wed, 25 May 2011 07:29:19 +0900
Message-ID: <BANLkTikEz0k8WTCAW9x7dYK2i3mm4c7tLA@mail.gmail.com>
Subject: Re: [PATCH] set_migratetype_isolate: remove unused variable.
From: Minchan Kim <minchan.kim@gmail.com>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 10:34 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
> Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

If it's trivial, please write log body down.
Anyway, nice catch.
Thanks.

-- 
Kind regards,
Minchan Kim
