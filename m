Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab1EMCv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 22:51:29 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35078 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1EMCv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 22:51:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=lFw0a+w6FgtCQUzA0aW8LETF+2XeQR4fdxh7Hdj7QoSz6ZiJED9zyG/mBBhCKqmSQ4
         nWNsd3TIiKU7ieV9UDk6av8OUQMJlNeYrFUyzdmQG21qra2EwA6lU3cxkEGKKh2mpVkB
         2S1pMEz7zfKtndj6wEfkHlWwXCWyu5eLn8ndk=
MIME-Version: 1.0
In-Reply-To: <20110426105910.F369.A69D9226@jp.fujitsu.com>
References: <20110426105045.F359.A69D9226@jp.fujitsu.com> <20110426105518.F35D.A69D9226@jp.fujitsu.com>
 <20110426105910.F369.A69D9226@jp.fujitsu.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 12 May 2011 22:51:05 -0400
Message-ID: <BANLkTin98Y=ADy2hbqQoz9p1u_yDi_h4MA@mail.gmail.com>
Subject: Re: (resend) [PATCH 4/4] blackfin: convert old cpumask API to new one
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 21:57, KOSAKI Motohiro wrote:
> old cpu_xxx() APIs is planned to removed later. then, converted.

ive merged this one too, thanks
-mike
