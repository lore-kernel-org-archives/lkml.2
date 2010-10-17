Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967Ab0JQU6l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 16:58:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62461 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932785Ab0JQU6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 16:58:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=q0epU9uLna+Fr8lU2M4xZb/WW7Ufz8qPwtVOtG3NCkxkMdsPVrbuvEc+Cs6MO4msKg
         +uW+dEgXLZk3D4M1ONeMG4NscRoLQ2JHExKbIWgWRWKj4zNd01wJhhud5tSNOBhRWfxq
         i4MzzjgNxt+jiC/LVXb9XTwhNo7+nqJXcr8BU=
MIME-Version: 1.0
In-Reply-To: <20101017121953.40831b35.rdunlap@xenotime.net>
References: <1287296545-21822-1-git-send-email-vapier@gentoo.org> <20101017121953.40831b35.rdunlap@xenotime.net>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sun, 17 Oct 2010 16:58:17 -0400
X-Google-Sender-Auth: x9xmBnKx5qHGHq48lAhEKsvhwig
Message-ID: <AANLkTim7iG0UuusoOvWU+V8PoOPeOK4MxV2cBR-u7vtG@mail.gmail.com>
Subject: Re: [PATCH] ad525x_dpot: default to off
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 15:19, Randy Dunlap wrote:
> On Sun, 17 Oct 2010 02:22:25 -0400 Mike Frysinger wrote:
>> From: Michael Hennerich <michael.hennerich@analog.com>
>>
>> No reason for this to be enabled by default.
>
> The default is automatically 'n', so please explain (more) why this is
> needed...?

we were seeing it turned on automatically.  maybe Michael can find the
reproduction testcase ...
-mike
