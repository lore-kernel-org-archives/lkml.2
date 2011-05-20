Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1ETNKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:10:41 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:40142 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971Ab1ETNKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:10:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=PNuHbYSIO6aFSZwchb2mXhccNXc6MSQXZSZnfzl/vAFKcsmdSXd2dQlQ1hRKRHZZ2c
         +lQis7ZOYCgVSTaAzNxw+0kZvTWkXGRu6wI9PlFXamLvo5PzFmYgGA1fz8EH+X70gfgr
         6UAn9E2RXEpFD3+GJBNfJPOlI+mnytm2jP2BE=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1105201336280.28291@pobox.suse.cz>
References: <1305807498-8785-1-git-send-email-benjamin.tissoires@enac.fr>
	<1305807498-8785-7-git-send-email-benjamin.tissoires@enac.fr>
	<alpine.LNX.2.00.1105201031560.28291@pobox.suse.cz>
	<BANLkTim1nGEbBo2Zf6gfTzAAZJK5vmpy6A@mail.gmail.com>
	<alpine.LNX.2.00.1105201336280.28291@pobox.suse.cz>
Date: Fri, 20 May 2011 15:10:38 +0200
X-Google-Sender-Auth: oZRRYq4MtS5RMyednDpHcRZT8-I
Message-ID: <BANLkTik=rmeMSH1-4=HWR-1k36BGrQ5nrg@mail.gmail.com>
Subject: Re: [PATCH 6/6] hid-multitouch: class MT_CLS_STANTUM is redundant
 with MT_CLS_CONFIDENCE
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 13:37, Jiri Kosina <jkosina@suse.cz> wrote:
> On Fri, 20 May 2011, Benjamin Tissoires wrote:
>
>> > is it intentional that you are leaving the hole in the numbering here?
>> >
>> > I don't think there would be any issue with re-numbering 7-10, would it?
>>
>> Well, the first time I tried to renumber those classes (to keep them
>> alphabetically sorted), I've been told not to do it. That's why I let
>> the hole in this case.
>> There won't be any issue in renumbering those classes (and we could sort them).
>> Maybe I can just send a new patch on top of this to sort them.
>
> OK. Well, I don't really care personally much, I was just wondering why
> leaving it unnecessarily sparse.
>
> I have applied the whole series now, thanks.
>
>> PS: and thank you very much for applying so quickly the last patches I
>> sent.
>
> I am preparing the tree for merge window push, so I rather have everything
> sorted out in the upcoming day or two.

Hi Jiri,

I'll make the patch right now. I'll test against our device and send
it. And I'll try not to send "last minute patch" during this merge
window... ;-)

Cheers,
Benjamin

>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
>
