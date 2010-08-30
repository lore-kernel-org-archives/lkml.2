Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab0H3OEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 10:04:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42233 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab0H3OEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 10:04:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=hvl8n0S0h/OtiQjD9cNiNRlk22s04eXtKc7z2ANVmINwXCYKPsO7sFtJXWjxIBdvuZ
         38LYYKW/H+YiO7kJuqMxxrQZ5UzScL/F1HRpRG3DS1V21rpksy1CZbxxaLMAWcAANcCU
         0BLwk2/xJMjkBkGXhLZoYEIctVeBUT64ckaSw=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/43] ptrace cleanups
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
	<20100830001454.DC8FD400D9@magilla.sf.frob.com>
Date: Mon, 30 Aug 2010 23:02:48 +0900
In-Reply-To: <20100830001454.DC8FD400D9@magilla.sf.frob.com> (Roland McGrath's
	message of "Sun, 29 Aug 2010 17:14:54 -0700 (PDT)")
Message-ID: <87aao4mc53.fsf@NHK-XNOTE.i-did-not-set--mail-host-address--so-tickle-me>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> writes:

> I am fine with the s/long/unsigned long/ signature changes.  Adding
> temporaries to avoid the repeated casts is fine too.  All that will
> compile away to the same code we have now.  But please do it without
> changing put_user/get_user calls to copy_{to,from}_user.  With a
> temporary or two you'll still have fewer casts than before.  IMHO you
> should at least do a separate follow-on patch for anything that actually
> changes the compiled code vs just the cosmetic type cleanups.
>

OK. I'll do that on next round.
Thanks.

-- 
Regards,
Namhyung Kim
