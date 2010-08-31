Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab0HaMRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:17:33 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51292 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab0HaMRc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:17:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=K1Sa0+l38vAQFNeFTz8kQKLg4spo/rlAN4ek7Lf5Wgq/10NuHyJ+yOHLakQdXnuEHy
         J6ryGLJrtsV3+iKBwLE+6UpmpBNzCjl03opQ2MjqyK905Falf+Cq39AhAADJYag83swA
         hrRXIpMPeUjvO/ZA8IR12kuNyLxrIfzLKhF1I=
MIME-Version: 1.0
In-Reply-To: <20100817054000.GB5095@cr0.nay.redhat.com>
References: <1282019131-30813-1-git-send-email-avar@v.nix.is>
	<20100817054000.GB5095@cr0.nay.redhat.com>
Date: Tue, 31 Aug 2010 12:17:31 +0000
X-Google-Sender-Auth: Fg1QPKlPA0qx3V6rINJaaTfV0k8
Message-ID: <AANLkTinwaFzcHauAXqDdAVEWWxHsMmfVt8mBYgBV72mg@mail.gmail.com>
Subject: Re: [PATCH] .gitignore: Ignore generated files in lib/raid6
From: =?UTF-8?B?w4Z2YXIgQXJuZmrDtnLDsCBCamFybWFzb24=?= <avar@v.nix.is>
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: torvalds@linux-foundation.org,
        David Woodhouse <dwmw2@tylersburg.infradead.org>,
        Linux is full of bugs <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 05:40, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Tue, Aug 17, 2010 at 04:25:31AM +0000, Ævar Arnfjörð Bjarmason wrote:
>>The Makefile in lib/raid6 will generate these files, and the clean
>>target will remove them, but they weren't being ignored by git.
>>
>>Signed-off-by: Ævar Arnfjörð Bjarmason <avar@v.nix.is>
>
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
>
> Thanks!

In case this fell through: Could you pick this up Linus. It's still
causing a dirty tree under "git status". Thanks.

>>---
>> lib/raid6/.gitignore |   16 ++++++++++++++++
>> 1 files changed, 16 insertions(+), 0 deletions(-)
>> create mode 100644 lib/raid6/.gitignore
>>
>>diff --git a/lib/raid6/.gitignore b/lib/raid6/.gitignore
>>new file mode 100644
>>index 0000000..ce56377
>>--- /dev/null
>>+++ b/lib/raid6/.gitignore
>>@@ -0,0 +1,16 @@
>>+#
>>+# Generated files
>>+#
>>+
>>+altivec1.c
>>+altivec2.c
>>+altivec4.c
>>+altivec8.c
>>+int1.c
>>+int16.c
>>+int2.c
>>+int32.c
>>+int4.c
>>+int8.c
>>+mktables
>>+tables.c
>>--
>>1.7.2.1.389.gc3d0b
>>
>>--
>>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>Please read the FAQ at  http://www.tux.org/lkml/
>
