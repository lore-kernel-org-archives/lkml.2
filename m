Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab0H0LQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:16:24 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:60745 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab0H0LQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:16:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=XFQWfooB8IHlkyW6ekysFYFxRta7WjFUeOANt84x3ng/ixtPZjP3XqKccw+dJXzKI8
         9ARcwc4rOmcj0gd5N634OwSyXlSz5JlQuDi4o0u6MjG0jlGRHLdgJYhBlOjDJ8hE7QD/
         akVhIz4N7dy6JtniHRAgu9UjWYPB7MKzUhlvk=
From: Namhyung Kim <namhyung@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 14/43] ptrace, frv: change signature of arch_ptrace()
References: <1282902149-12991-15-git-send-email-namhyung@gmail.com>
	<1282902149-12991-1-git-send-email-namhyung@gmail.com>
	<4072.1282906906@redhat.com>
Date: Fri, 27 Aug 2010 20:15:57 +0900
In-Reply-To: <4072.1282906906@redhat.com> (David Howells's message of "Fri, 27
	Aug 2010 12:01:46 +0100")
Message-ID: <87aao8gvbm.fsf@NHK-XNOTE.i-did-not-set--mail-host-address--so-tickle-me>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:
> That description means nothing.  Commit
> f76671df26ef06321480e702770f88f61272be29 is not upstream.
>

Hi,
Thank you for noticing. My bad.
I just wanted to let you know it depends on that.
What is the proper way to handle this?

-- 
Regards,
Namhyung Kim


