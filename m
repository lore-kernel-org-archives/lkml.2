Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab1CQK7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 06:59:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49658 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab1CQK7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 06:59:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=G/WSNhuhwClE4Zra6HUeXX2mQ0T1EshHq+bjavRfARWo7TxYkAHB3LsPt2kSJnoWC4
         pWvkbq4sEtaw98YJqtNVnY07V69WvDCKSsR7I3o5ci/jpkDO/+MWO/83Sstx0lTtYBsD
         CMPeRWQkrb0JXC1SrJopoy9TvQewDoTcXJK3k=
MIME-Version: 1.0
In-Reply-To: <20110317064523.GA1995@ucw.cz>
References: <20110317064523.GA1995@ucw.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 17 Mar 2011 18:58:11 +0800
Message-ID: <AANLkTik1CdT4k8SJop7b-MjR27RzF7a=i7WuodNKJi+J@mail.gmail.com>
Subject: Re: reboot/kexec in 2.6.38
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
        zaurus-devel@www.linuxtogo.org, Marek Vasut <marek.vasut@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 2:45 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> I got report that  reboot/kexec does not work in recent kernels.
>
> I tried both kexec and reboot in 2.6.38, and it worked ok. Maybe
> config issue?

I think it's config issue. Never heard of this.

>                                                                        Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
