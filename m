Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742Ab0H0PxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 11:53:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58316 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab0H0PxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 11:53:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=CJPPssUOffdYdt/t6MsIzNKP10Nw3vnUUIKZ19clAhqd0LaO6AxXIsFmTH5LpzOB/N
         ku2vNzoHw+4bi/62zj2Yy2Gwwg1b1CUfM6EwbIy/fuuqMwwIvF5Vxf/KerDqg6PvHt0S
         kTd6nJjfEc3F/6kN5dFYTef9RsU8pqcbCa4Uw=
From: Namhyung Kim <namhyung@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 14/43] ptrace, frv: change signature of arch_ptrace()
References: <8762ywgqkt.fsf@NHK-XNOTE.i-did-not-set--mail-host-address--so-tickle-me>
	<87aao8gvbm.fsf@NHK-XNOTE.i-did-not-set--mail-host-address--so-tickle-me>
	<1282902149-12991-15-git-send-email-namhyung@gmail.com>
	<1282902149-12991-1-git-send-email-namhyung@gmail.com>
	<4072.1282906906@redhat.com> <5542.1282911123@redhat.com>
	<7665.1282915390@redhat.com>
Date: Sat, 28 Aug 2010 00:53:08 +0900
In-Reply-To: <7665.1282915390@redhat.com> (David Howells's message of "Fri, 27
	Aug 2010 14:23:10 +0100")
Message-ID: <871v9kgihn.fsf@NHK-XNOTE.i-did-not-set--mail-host-address--so-tickle-me>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:
> If patch 3 breaks all architectures, such that none of them then compile, this
> is bad.  The fixes should be combined into that patch.
>
> If it breaks them such that there are warnings, but they still compile, we can
> probably live with that, but it's still icky.
>

OK. I'll combine those patches into one on next round.
Thanks.

-- 
Regards,
Namhyung Kim

