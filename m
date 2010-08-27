Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab0H0QVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 12:21:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50031 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab0H0QVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 12:21:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=gwJYEaxeYHksP/Oku2YFSCEaGMIhvxJz5qbUUkroQX7VONTlkajUDkdvJybe74Brmv
         qQ1GKTLsvuHxVw3Ziwvh7a36OiXGjQ1u+FmpShsnXJKDVnleYLQlStFb59bK36beqPz+
         m02ex3RZ2XUu3BhibawWqNtXeWALsvDdtGQrs=
From: Namhyung Kim <namhyung@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 03/43] ptrace: change signature of arch_ptrace()
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
	<1282902149-12991-4-git-send-email-namhyung@gmail.com>
	<201008271628.40023.arnd@arndb.de>
Date: Sat, 28 Aug 2010 01:20:55 +0900
In-Reply-To: <201008271628.40023.arnd@arndb.de> (Arnd Bergmann's message of
	"Fri, 27 Aug 2010 16:28:39 +0200")
Message-ID: <87occof2mw.fsf@NHK-XNOTE.i-did-not-set--mail-host-address--so-tickle-me>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:
> Would it be possible to rearrange your patches so that you don't break
> anything in the middle? I think merging all the trivial 'change signature'
> patches into one would also make reviewing easier. Nobody in their
> right mind is looking through a full series of 43 patches, especially
> if they do not make sense on their own, but one patch that changes a
> function signature tree-wide would be looked at by many people and can
> be applied standalone.
>

OK. Will combine those.
BTW, one thing I wonder is it will have huge CC list of arch maintainers
in commit message, so is it usual? or is there other way?


-- 
Regards,
Namhyung Kim
