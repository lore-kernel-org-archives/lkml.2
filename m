Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab0HaOCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 10:02:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757306Ab0HaOCA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 10:02:00 -0400
From: Andreas Schwab <schwab@redhat.com>
To: =?utf-8?B?w4Z2YXIgQXJuZmrDtnLDsA==?= Bjarmason <avar@v.nix.is>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        torvalds@linux-foundation.org,
        David Woodhouse <dwmw2@tylersburg.infradead.org>,
        Linux is full of bugs <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] .gitignore: Ignore generated files in lib/raid6
References: <1282019131-30813-1-git-send-email-avar@v.nix.is>
	<20100817054000.GB5095@cr0.nay.redhat.com>
	<AANLkTinwaFzcHauAXqDdAVEWWxHsMmfVt8mBYgBV72mg@mail.gmail.com>
X-Yow: I just had a MAJOR CONTRACT DISPUTE with SUZANNE SOMERS!!
Date: Tue, 31 Aug 2010 16:01:40 +0200
In-Reply-To: <AANLkTinwaFzcHauAXqDdAVEWWxHsMmfVt8mBYgBV72mg@mail.gmail.com>
	(=?utf-8?B?IsOGdmFyIEFybmZqw7Zyw7A=?= Bjarmason"'s message of "Tue, 31 Aug
 2010 12:17:31
	+0000")
Message-ID: <m3pqwykhiz.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ævar Arnfjörð Bjarmason <avar@v.nix.is> writes:

> On Tue, Aug 17, 2010 at 05:40, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> On Tue, Aug 17, 2010 at 04:25:31AM +0000, Ævar Arnfjörð Bjarmason wrote:
>>>The Makefile in lib/raid6 will generate these files, and the clean
>>>target will remove them, but they weren't being ignored by git.
>>>
>>>Signed-off-by: Ævar Arnfjörð Bjarmason <avar@v.nix.is>
>>
>> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
>>
>> Thanks!
>
> In case this fell through: Could you pick this up Linus. It's still
> causing a dirty tree under "git status". Thanks.

It's already on its way, see
<http://permalink.gmane.org/gmane.linux.raid/29357>.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
