Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab1BRPYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 10:24:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44275 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab1BRPYj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 10:24:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GXuxxUPeMMLERJ0ZqgX62fJjrTaqd0O5GM4HwH8l4+4k8Q1HNgg6aRnWWw9VuWIVNq
         eoiuQGiNqpVbmOCfb0S3Z5qljMReinAHie86dfym2uZbokfvgMFi0YU5PMpDGolaNW/2
         +Ihh+K6YNP/WU7fwMXzZzMboE0lg7Rx/69XxE=
MIME-Version: 1.0
In-Reply-To: <AANLkTin0X-ST=rZqwfCA0i5VGCh5ygYXyZFdndiDgR_2@mail.gmail.com>
References: <4D5DB83D.80205@snapgear.com>
	<AANLkTin0X-ST=rZqwfCA0i5VGCh5ygYXyZFdndiDgR_2@mail.gmail.com>
Date: Fri, 18 Feb 2011 16:24:13 +0100
X-Google-Sender-Auth: BbUETa8kvN8DYnkBvIbNVX5Vs-g
Message-ID: <AANLkTim=kQOMyKqOEkw5iQjpGhDf0YGMe1ZTnJZkKfr7@mail.gmail.com>
Subject: Re: merge of m68knommu and m68k arch branches?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Steven King <sfking00@yahoo.com>,
        uClinux development list <uclinux-dev@uclinux.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Greg Ungerer <gregungerer@westnet.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 12:27, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Fri, Feb 18, 2011 at 01:07, Greg Ungerer <gerg@snapgear.com> wrote:
>> I would like to put up for discussion a merge of the m68knommu and
>> m68k arch branches.
>>
>> Attached is a script and patch that does a kind of brute force
>> simplistic merge of the directories and files. (Thanks to Stephen King
>> <sfking@fdwdc.com> for the initial version of this script, and to
>> Sam Ravnborg for the m68k includes merge script this was based on).
>> Nothing outside of the arch/m68k and arch/m68knommu directories is
>> touched, and in the end there is no more arch/m68knommu. To apply you
>> simply run the script from the top of a current kernel git tree (I used
>> 2.6.38-rc5 for testing) and then apply the patch.
>
> Building...

Builds fine (all test configs), runs on ARAnyM.

Let's go ahead?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
