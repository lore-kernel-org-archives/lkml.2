Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab1E3Hbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 03:31:35 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45136 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1E3Hbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 03:31:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=N4BCL+rnqtKpwdmU4Vt91SVyCrg5FlGD0WSQPTASHX6MBIMfgXA3ZAkmPXLqBOyxkV
         VFGYObS4u5+s2GLudlrTM1Fxwo7agx0z1uPoQTmLbMbPl4zJflo+zbNVRtLjaG5+I5xz
         jcXYY/c5D2zCIUwgar0NyB2XYIYYW/Uu5qQlI=
Subject: Re: [PATCH] shrinker API change fallout
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, sfrench@samba.org, yinghan@google.com
In-Reply-To: <20110529124608.GI11521@ZenIV.linux.org.uk>
References: <20110529124608.GI11521@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 May 2011 10:26:09 +0300
Message-ID: <1306740369.4405.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-29 at 13:46 +0100, Al Viro wrote:
> commit 1495f230fa7750479c79e3656286b9183d662077 changed the API of ->shrink(),
> but missed ubifs and cifs instances.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Thanks for spotting this.

Acked-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

