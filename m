Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab1CRHY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 03:24:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45054 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab1CRHYw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 03:24:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZvUd0TVwVyR1yHtttG9Q/2bcIYbG5XcRf93/sLISttz4M2jKbdmz5L+lNNxRVmKAsI
         hl0IirMKTiv+JXr7/ibFOmGKSpfYxKHK+4AqiOKXGUdxC0CmSKMFNcZTeQGJ39AgPYZp
         G1cmuOb7H/ZVn+PdqMKvGGBxWVYR/5qJhdaxA=
MIME-Version: 1.0
In-Reply-To: <4D82A068.7020101@snapgear.com>
References: <4D5DB83D.80205@snapgear.com>
	<AANLkTin0X-ST=rZqwfCA0i5VGCh5ygYXyZFdndiDgR_2@mail.gmail.com>
	<AANLkTim=kQOMyKqOEkw5iQjpGhDf0YGMe1ZTnJZkKfr7@mail.gmail.com>
	<4D5EEEBB.7050708@snapgear.com>
	<AANLkTimmfUJASL47Cs80FJ2mkx3PPvAX57x43nF09tns@mail.gmail.com>
	<4D61A986.3060308@snapgear.com>
	<AANLkTimtr0JbmM2PNtGRyAKE7kNr_FXd==ZC3bM82xsG@mail.gmail.com>
	<4D82A068.7020101@snapgear.com>
Date: Fri, 18 Mar 2011 08:24:50 +0100
X-Google-Sender-Auth: PUUNjbFHtXHHBZWmc0EDLeJMiSE
Message-ID: <AANLkTikr=HVVKxuTqwh8U=LDmaMCMpOkdUxdo+pw_tz4@mail.gmail.com>
Subject: Re: merge of m68knommu and m68k arch branches?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        uClinux development list <uclinux-dev@uclinux.org>,
        Greg Ungerer <gerg@uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Fri, Mar 18, 2011 at 00:59, Greg Ungerer <gerg@snapgear.com> wrote:
> Looks like we both have our changes for m68k and m68knommu in Linus'
> git tree for this merge window. Do you plan to push anything else?

Nothing planned for now.

> If you are done I will prepare a single git commit on the m68knommu
> git tree that merges the m68knommu and m68k arch branches. I will
> post here again for one last check over early next week, and if
> everyone is happy I will ask Linus to pull it later next week.
>
> How does that sound?

Sounds great! Thx!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
