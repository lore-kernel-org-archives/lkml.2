Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab0H3OqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 10:46:00 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54095 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab0H3Op6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 10:45:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=Kl0DL8hk8oOZcfwk/IFBu/rBrLQLtsAuPu82OCG/dD3HeRr+1K282/MgQBNuS++lD2
         pKBM/9LICm7q2/cqXSHVZSJsKi9bWp0Bw1j50HQvxTFpNY/hYMD7vSUweCvUZX3zdaNH
         utsfOpXRUUL+YsdX2aHiu/yW5RLmJcajE2CQs=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <20100830153953.1e5abc71@schatten.dmk.lab>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
	<4AUWBNzTkbD.A.mj.QGueMB@chimera>
	<AANLkTikpoH-_od-SL3=Q7a=xbsraE4rYGicx7mmS92Cw@mail.gmail.com>
	<20100830153953.1e5abc71@schatten.dmk.lab>
Date: Mon, 30 Aug 2010 15:45:54 +0100
Message-ID: <AANLkTi=2c8FiPO6Mx9YLEscXx8FXxRPZWXyAusTpgwuJ@mail.gmail.com>
Subject: Re: [Bug #16881] [REGRESSION, Radeon-KMS] 2.6.36-rc1,2 - missing
 textures in 0 A.D.
From: trapDoor <trapdoor6@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 2:39 PM, Florian Mickler <florian@mickler.org> wrote:
>
>
> On Mon, 30 Aug 2010 10:54:41 +0100
> trapDoor <trapdoor6-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Sun, Aug 29, 2010 at 11:36 PM, Rafael J. Wysocki <rjw-KKrjLPT3xs0@public.gmane.org> wrote:
>> > This message has been generated automatically as a part of a summary report
>> > of recent regressions.
>> >
>> > The following bug entry is on the current list of known regressions
>> > from 2.6.35.  Please verify if it still should be listed and let the tracking team
>> > know (either way).
>> >
>> >
>> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16881
>> > Subject         : [REGRESSION, Radeon-KMS] 2.6.36-rc1,2 - missing textures in 0 A.D.
>> > Submitter       :  <trapdoor6-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> > Date            : 2010-08-24 12:20 (6 days old)
>> >
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>> >
>>
>> There was at least one drm pull between 2.6.36-rc2 and -rc3. So I
>> tested on -rc3 and I confirm that the issue is still present.
>>
>> I was going to update the bugzilla entry but it won't let me log in at
>> this moment.
>>
>
> It seems to work now again. I've updated the entry for you.
>
> Thx,
> Flo
>
>

Thanks Florian.

--
Tomasz
