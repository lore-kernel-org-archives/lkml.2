Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab0FGFfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 01:35:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46559 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab0FGFfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 01:35:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=bVsQiSNBoW6sxpke8W/eaAlyni77EtSN5/cqhBZiLTs2kMfsxJvjtd+VxL1K5JJ8xF
         sR/RxQO7CMHlVKIL7d6jZjRZmQukBkuTii3RsLJqqR3cK0YS960xEQgP5TsjrH8bY0/v
         cLwrM2KQjltGdtVuwtH+fNZfvFZdkLfPXIOyk=
MIME-Version: 1.0
In-Reply-To: <AANLkTimAqHgKkNdvcLvw6fi301dD2PCO0zH2Ui_LpNgV@mail.gmail.com>
References: <1275379286-10453-1-git-send-email-ngupta@vflare.org>
	<1275379286-10453-2-git-send-email-ngupta@vflare.org>
	<AANLkTimjc8eZY2IqbeZUR7VsWVspZ4ilUz3LPAUIiZuU@mail.gmail.com>
	<20100604121957.d9bc55ae.akpm@linux-foundation.org>
	<AANLkTikzGnaJzZLq9Kd9JnMzGlg35-21T8A-zGmH1Ugn@mail.gmail.com>
	<AANLkTimAqHgKkNdvcLvw6fi301dD2PCO0zH2Ui_LpNgV@mail.gmail.com>
Date: Mon, 7 Jun 2010 08:35:37 +0300
X-Google-Sender-Auth: 5Nx7l68NrFukI5Fj--9PMUTI1T4
Message-ID: <AANLkTik3f5kWE_Vr5NdjVUnmlqKuR20sUhwv4xrsEJUq@mail.gmail.com>
Subject: Re: [PATCH 1/4] Support generic I/O requests
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
       Greg KH <greg@kroah.com>, Ed Tomlinson <edt@aei.ca>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

On Mon, Jun 7, 2010 at 2:32 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> AFAIR, mm forks haven't been interest in reviewing the code except
> allocator at that time. but at least, Greg or someone should have Cced
> one maintainer or mailing list related to patches to notice them.
> "It's growing in here(ie, staging) and be ready to go to the
> mainline". :)

Like I said, all patches have been discussed on LKML and Hugh Dickins
was CC'd because he's the swap maintainer. So the intent here was
always to make sure relevant people would see it but now looking back,
we ought to have CC'd linux-mm and maybe block maintainer(s) as well.

                        Pekka
