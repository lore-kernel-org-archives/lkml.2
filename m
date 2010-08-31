Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab0HaOJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 10:09:26 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61079 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab0HaOJZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 10:09:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Q3ZIAcxQFx3vQs/iVx+I0CfbRyTDGVHTNN4nyVBAWI1S5O37/gcyC628gSrzhra2Gs
         Fr3g78sfH16TNbVb17S5TNaa+JScs0sX9iIVPynBCAYqYikgWr4p1b+ThHLitG78GkOb
         mY8AHf9nUZrS9FuhUMkozSnfF8HqTTotJd2C4=
MIME-Version: 1.0
In-Reply-To: <m3pqwykhiz.fsf@hase.home>
References: <1282019131-30813-1-git-send-email-avar@v.nix.is>
	<20100817054000.GB5095@cr0.nay.redhat.com>
	<AANLkTinwaFzcHauAXqDdAVEWWxHsMmfVt8mBYgBV72mg@mail.gmail.com>
	<m3pqwykhiz.fsf@hase.home>
Date: Tue, 31 Aug 2010 14:09:24 +0000
X-Google-Sender-Auth: rBol05b5NN4peEbgRo8ap7DTYqI
Message-ID: <AANLkTi=wuBRLMERjq_fCWu95=QmhNkt-HxpDa1LMQcc9@mail.gmail.com>
Subject: Re: [PATCH] .gitignore: Ignore generated files in lib/raid6
From: =?UTF-8?B?w4Z2YXIgQXJuZmrDtnLDsCBCamFybWFzb24=?= <avar@v.nix.is>
To: Andreas Schwab <schwab@redhat.com>
Cc: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
        torvalds@linux-foundation.org,
        David Woodhouse <dwmw2@tylersburg.infradead.org>,
        Linux is full of bugs <linux-kernel@vger.kernel.org>,
        Neil Brown <neilb@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 14:01, Andreas Schwab <schwab@redhat.com> wrote:
> Ævar Arnfjörð Bjarmason <avar@v.nix.is> writes:
>
>> On Tue, Aug 17, 2010 at 05:40, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>>> On Tue, Aug 17, 2010 at 04:25:31AM +0000, Ævar Arnfjörð Bjarmason wrote:
>>>>The Makefile in lib/raid6 will generate these files, and the clean
>>>>target will remove them, but they weren't being ignored by git.
>>>>
>>>>Signed-off-by: Ævar Arnfjörð Bjarmason <avar@v.nix.is>
>>>
>>> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
>>>
>>> Thanks!
>>
>> In case this fell through: Could you pick this up Linus. It's still
>> causing a dirty tree under "git status". Thanks.
>
> It's already on its way, see
> <http://permalink.gmane.org/gmane.linux.raid/29357>.

Thanks. I didn't spot that since it came after my report and didn't
reference it (so it didn't appear in my searches).
