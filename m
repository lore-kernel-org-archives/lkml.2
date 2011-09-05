Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab1IEIir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 04:38:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49540 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1IEIim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 04:38:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ8eaTxPRbEGbFtME9HEnR=vUtvCOzkDoRA51AudpcPKcGeOvQ@mail.gmail.com>
References: <CAJ8eaTxPRbEGbFtME9HEnR=vUtvCOzkDoRA51AudpcPKcGeOvQ@mail.gmail.com>
Date: Mon, 5 Sep 2011 14:08:41 +0530
Message-ID: <CAJ8eaTxaUfdX7DiXuAA=18u_m+ESA7fwwkw1zCSF9HrsoC-ydQ@mail.gmail.com>
Subject: Re: Kernel crash (2.6.35.13)
From: naveen yadav <yad.naveen@gmail.com>
To: linux-mm <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding linux-arm

On Thu, Sep 1, 2011 at 4:10 PM, naveen yadav <yad.naveen@gmail.com> wrote:
> Dear All,
>
> I am running a simple test program that just do malloc and memset. The
> testprogram is run using below attached script
>
> while true
> do
> ./stress &
> ./stress &
> ./stress &
> ./stress &
> sleep 1
> done
>
>
> we got this issue on embedded Target.
>
> After analysis we found that most of task(stress_application) is in D
> for uninterruptible sleep.
> application           state
>
> stress                  x
> stress                  D
> stress                  x
> stress                  D
> stress                  x
> stress                  D
> stress                  x
> sleep                   D
>
> So I observe after 10-15 min Kernel crash with
>
> Kernel panic - not syncing: Out of memory and no killable processes...
>
>
> I am attaching Kernel Crash log + Test application.
>
> Thanks
>
