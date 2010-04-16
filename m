Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab0DPGZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 02:25:42 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:9870 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab0DPGZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 02:25:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=kf11g2/j9MwuMw/ub0NB1i2qnQcdAjJrQXPrdp9f+XxFt38DGYicCyNpp2sjybLoFZ
         QfNi94UOirzxBdnkcqqG4YZiSQnSol1l+eB+9YkFJvTm1CwNqy+XaWrAcfXwiypfkNJP
         u7OjUakqj452wHcVAk+iyGntWv9jMdf8PUteQ=
MIME-Version: 1.0
In-Reply-To: <20100415180314.GC1443@ucw.cz>
References: <20100415180314.GC1443@ucw.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 16 Apr 2010 14:25:16 +0800
Message-ID: <x2qf17812d71004152325v26785671r23aafd9444614590@mail.gmail.com>
Subject: Re: 2.6.34-rc3 vs zaurus spitz: mistery solved
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
       Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       zaurus-devel@www.linuxtogo.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 2:03 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> For some reason, spitz will hang very early in boot with SLUB. With
> SLOB, it boots fine.
>

Weird, just wondering for what specific reason. Pavel, could you possibly
paste the failure log if possible?

> SLUB worked fine in 2.6.33 and SLOB is hidden under CONFIG_EMBEDDED,
> so it took a while to figure out.
>                                                                Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
