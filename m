Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab1E1LRH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 07:17:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38513 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab1E1LRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 07:17:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=iTNYL3wHgQi1O1AnoOHaTipjUxxsvGWGqUn0i6I6szk9VjoCwfCUUiC8g/yxR4DbkQ
         clFFxunD+giZLj4Sc4sgcSzsY4mw3sgXskflJedkdbzyuYwvzIMpaFvM7RaP6ic8C+gz
         nwH9IFM5zX/Qwe4026aDhszRETeij/ElsT9AI=
MIME-Version: 1.0
In-Reply-To: <1306579592.2527.2.camel@localhost.localdomain>
References: <1306579592.2527.2.camel@localhost.localdomain>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sat, 28 May 2011 07:16:44 -0400
X-Google-Sender-Auth: d0thK55Tg6NLxnQQRTm0KS83sEk
Message-ID: <BANLkTimAWEMh49NV0wk5QqaPmzDi6r2kkw@mail.gmail.com>
Subject: Re: Boot failed on latest 2.6.39
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 6:46 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> With attached config, boot failed on my core i3 machine. Bisection log is also attached (bisectlog). Probably, the patchset from luto@mit.edu (https://lkml.org/lkml/2011/5/26/433) breaks things up.
> It seems the following commit is responsible:
>
>  commit f144a6b4d1688675d88990e29567b2335b48205e
>  Author: Andy Lutomirski <luto@MIT.EDU>
>  Date:   Mon May 23 09:31:30 2011 -0400
>

I would bet it's one of the other commits in the series, not that one.

Can you try this:

http://git.kernel.org/?p=linux/kernel/git/rostedt/linux-2.6-trace.git;a=commit;h=89e1be50c68eb5e58b873dce87bbac627ee18d1f

If that doesn't fix it, what was the failure?  Attempted to kill init
is most likely, but whatever showed up on the screen would be helpful.

--Andy

>
>
>
>
