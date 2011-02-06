Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab1BFQ5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 11:57:21 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33836 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1BFQ5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 11:57:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LWlFn/VoW2HFkSjHd5oTaG1LJgepflGIQUsRosLDTSWW/mMx/e51YwWF+AnVlGugFW
         +5yooyHqckb5xh/TqPaKpRG1FJbB3+maavSUMXZfqChfbps11P87aOs/l9CHPj0Ypo6U
         9q5aeVLoE3kmADEasTf5FUlLk1Vrx/NR96B6M=
MIME-Version: 1.0
In-Reply-To: <20110206165524.GG22170@cathedrallabs.org>
References: <AANLkTi=vBv_a+X3MrgyDevss9H92vBJ51eON_qyMJW4=@mail.gmail.com>
	<20110206165524.GG22170@cathedrallabs.org>
Date: Sun, 6 Feb 2011 17:57:19 +0100
Message-ID: <AANLkTimZq3-zuiA940dK7AmszBW-TEHP0JHz7FGHSmgu@mail.gmail.com>
Subject: Re: [PATCH] uinput strnlen bugfix
From: David Herrmann <dh.herrmann@googlemail.com>
To: Aristeu Rozanski <aris@cathedrallabs.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=90e6ba53a8721d6287049ba002e4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--90e6ba53a8721d6287049ba002e4
Content-Type: text/plain; charset=ISO-8859-1

On Sun, Feb 6, 2011 at 5:55 PM, Aristeu Rozanski <aris@cathedrallabs.org> wrote:
> and where's the patch? :^)
>
> --
> Aristeu
>

ah, embarrasing.., sorry.
I attached the patchfile.

David

--90e6ba53a8721d6287049ba002e4
Content-Type: text/x-patch; charset=US-ASCII; name="uinput_fix.diff"
Content-Disposition: attachment; filename="uinput_fix.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gju75t3a0

LS0tIG9sZC9kcml2ZXJzL2lucHV0L21pc2MvdWlucHV0LmMJMjAxMS0wMi0wNiAxNzo0MDoyNC45
NTE0NTQ2NTYgKzAxMDAKKysrIG5ldy9kcml2ZXJzL2lucHV0L21pc2MvdWlucHV0LmMJMjAxMS0w
Mi0wNiAxNzo0MToxNi43NDc0NTQ2NTQgKzAxMDAKQEAgLTM3Miw4ICszNzIsOCBAQAogCiAJdWRl
di0+ZmZfZWZmZWN0c19tYXggPSB1c2VyX2Rldi0+ZmZfZWZmZWN0c19tYXg7CiAKLQlzaXplID0g
c3Rybmxlbih1c2VyX2Rldi0+bmFtZSwgVUlOUFVUX01BWF9OQU1FX1NJWkUpICsgMTsKLQlpZiAo
IXNpemUpIHsKKwlzaXplID0gc3Rybmxlbih1c2VyX2Rldi0+bmFtZSwgVUlOUFVUX01BWF9OQU1F
X1NJWkUpOworCWlmICghc2l6ZSsrKSB7CiAJCXJldHZhbCA9IC1FSU5WQUw7CiAJCWdvdG8gZXhp
dDsKIAl9Cg==
--90e6ba53a8721d6287049ba002e4--
