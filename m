Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab1CKMZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 07:25:44 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57212 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab1CKMZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 07:25:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=hhxzKAkTCBm66e8FRIh+tiTe9MP7f0NU1t64CrPjYNukvcN4iHeHLOu5q5iSVmzV6u
         lwZLLGf55Hz5KaPKYrKS6Y4IeMvyEhf1z5UAWDxm7lSH0r+MUlF3O6uCSSEIWsFhvYEQ
         A4336AFPePJ4CUceRnP43S2zWtv0xH8inZw4o=
MIME-Version: 1.0
Date: Fri, 11 Mar 2011 13:21:52 +0100
X-Google-Sender-Auth: AewUIC9i77DsxCRQsjv1nS0gJxs
Message-ID: <AANLkTi=Hg4s5kEMQZu_KGePf4W_7jAFm0_WifM9W3PR6@mail.gmail.com>
Subject: [next] xfs: error: called object 'panic' is not a function
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: xfs-masters@oss.sgi.com, xfs@oss.sgi.com
Cc: Linux-Next <linux-next@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://kisskb.ellerman.id.au/kisskb/buildresult/3977742/:

| fs/xfs/linux-2.6/xfs_message.c:116: error: called object 'panic' is
not a function
| make[3]: *** [fs/xfs/linux-2.6/xfs_message.o] Error 1

Lemme guess, the problem fixed by commit
cf78859f520f8275318f47d7864f4459d940cb6b (xfs: Do not name variables "panic")
has reincarnated somewhere else?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
