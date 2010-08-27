Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab0H0QNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 12:13:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46752 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab0H0QNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 12:13:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=kaLOuKLP23FqEwM+YEI5G5atKr3Ib3acdTbeMQXvIjqicS97/oIKXQUBuf5sSQrDz/
         4vrln1pA5D+F6meA/f+iPVX2uHdPqssenKUMOC4UOu0CvHR+cEuQ8Hw+8hgov4UBrVqr
         mswucO35qYzJpdDQvZoltBl9JY/ZvnUX2hvCg=
From: Namhyung Kim <namhyung@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 02/43] ptrace: cleanup ptrace_request()
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
	<1282902149-12991-3-git-send-email-namhyung@gmail.com>
	<201008271623.01761.arnd@arndb.de>
Date: Sat, 28 Aug 2010 01:13:35 +0900
In-Reply-To: <201008271623.01761.arnd@arndb.de> (Arnd Bergmann's message of
	"Fri, 27 Aug 2010 16:23:01 +0200")
Message-ID: <87sk20f2z4.fsf@NHK-XNOTE.i-did-not-set--mail-host-address--so-tickle-me>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:
> If you introduce two pointers, 'siginfo_t __user *usiginfo' and
> 'unsigned long __user *datap' instead of just 'datap', you can use
> get_user/put_user everywhere, which would make the code better readable
> and faster.
>
> Otherwise this change looks good.
>

Despite I don't know how much it can run faster, I just want to keep it as is
unless it would be a serious mistake. :-)

-- 
Regards,
Namhyung Kim


