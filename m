Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933512Ab0FCBmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 21:42:25 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56180 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756Ab0FCBmX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 21:42:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UccxfDnFmNSlU1pfbQh/pPuveEn6IJJbJ2OFoYpvCr2zEYzAOqSUp4c6fr40d63IiE
         cZ8uTqHcorg9WdZIWikxdRnamcRc2s+HTMVsxwn/sGfxsguSG67gJ6kbDS/KEHyc+Hod
         mHKOK8m5s6TYa2CawF+xxeKOZgTPjBJ1Ajgig=
MIME-Version: 1.0
In-Reply-To: <20100603011840.GA4971@outflux.net>
References: <20100602222302.GC6554@outflux.net>
	<AANLkTinnzPBlbB6q2v9Bfg55Rum809ko-K0ecWQJwWbB@mail.gmail.com>
	<20100603011840.GA4971@outflux.net>
Date: Thu, 3 Jun 2010 09:42:21 +0800
Message-ID: <AANLkTikWCDptyzts8wC2Rf7SMr5HvrHdVd5BniNnbHhb@mail.gmail.com>
Subject: Re: [PATCH v4] fs: allow protected cross-uid sticky symlinks
From: Dave Young <hidave.darkstar@gmail.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 9:18 AM, Kees Cook <kees.cook@canonical.com> wrote:
> Hi,
>
> On Thu, Jun 03, 2010 at 08:51:28AM +0800, Dave Young wrote:
>> On Thu, Jun 3, 2010 at 6:23 AM, Kees Cook <kees.cook@canonical.com> wrote:
>> > v2:
>> >  - moved sysctl extern into security.h.
>>
>> Not in v4?
>>
>> > v3:
>> >  - move into VFS core.
>> >  - rename sysctl, invert logic.
>
> Right, as part of the "move out of security/" the sysctl moved to live in
> fs/namei.c (and therefore needed an extern in kernel/sysctl.c).

Then linux/fs.h is the place to go
sysctl_nr_open_min and sysctl_nr_open_max can go there as well.

>
> -Kees
>
> --
> Kees Cook
> Ubuntu Security Team
>



-- 
Regards
dave
