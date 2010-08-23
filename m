Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0HWGsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 02:48:12 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39033 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab0HWGsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 02:48:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=p9IA6vS/TL2gnyOwOCYG+Af9bqRJEcib142bysfaqXMYh2m+X0MRguEIVZ8lgVUnye
         iRvs+AffXj2ZAM6oZQ10+K25vQ5I+Csxwa2ZKA2ZUhVOO69WU1hVIAM17vHVnQ4Hu++L
         bme1NxwVq6+hhHevowMnSOZELH6T1dJ+WLdUw=
MIME-Version: 1.0
In-Reply-To: <20100818083346.GA6308@july>
References: <20100818083346.GA6308@july>
Date: Mon, 23 Aug 2010 08:48:09 +0200
Message-ID: <AANLkTinuFrE0ZpTpgaEQr5GYFXzGjHYq7FC-sY-UiVFi@mail.gmail.com>
Subject: Re: [PATCH] Ramoops: use the platform data structure instead of
 module params
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/18 Kyungmin Park <kmpark@infradead.org>:
> From: Kyungmin Park <kyungmin.park@samsung.com>
>
> As each board and system has different memory for ramoops. It's better to define the platform data instead of module params.
>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---

It seems good. Currently there isn't any code that register a ramoops
device, isn't it?
