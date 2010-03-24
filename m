Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab0CXWLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 18:11:06 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:46186 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab0CXWLA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 18:11:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mqIqcBtP4objKctdwDaCaBlOy7nDFoMHHEHqcdtv4oZ5tr0bzaXkkGHNQxXo72GRsD
         c2BG3JFwplnWpjcJihzjoKzLFJ9ylvgWHwbhG1eWNX+MAvI8YcDj02yXbYct8mUy74+K
         Rz/+2I8Z4ENiCMftc0vxzQCYrTRDm8LR+DnCE=
MIME-Version: 1.0
In-Reply-To: <g766ycf6hwz4din58tUYAxe124vaj_firegpg@mail.gmail.com>
References: <b2cc26e41003180742k435cbc7eqcf84a65791ee36c@mail.gmail.com>
	 <g766ycf6hwz4din58tUYAxe124vaj_firegpg@mail.gmail.com>
Date: Wed, 24 Mar 2010 23:10:58 +0100
Message-ID: <b2cc26e41003241510k64fdcf3udbe9a4ca102f9792@mail.gmail.com>
Subject: Re: execve() returns ENOENT when ld-linux.so isn't found
From: Olaf van der Spek <olafvdspek@gmail.com>
To: drepper@gmail.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 2:49 PM,  <drepper@gmail.com> wrote:
> On Thu, Mar 18, 2010 at 07:42, Olaf van der Spek <olafvdspek@gmail.com>
> wrote:
>>
>> $ ls -l
>> -rwxr-xr-x 1 olaf olaf 560165 2010-03-18 15:21 xwis
>> $ ./xwis
>> -bash: ./xwis: No such file or directory
>
> Your shell should handle this.  I'm not sure whether it's in the upstream

Why?
And why can't the kernel returned the more appropriate ENOEXEC?

> bash (it should be) but I wrote a long, long time ago a patch which produces
> better messages.  On my system I get:
>
> $ ./u
> bash: ./u: /some/path/does-not-exist: bad ELF interpreter: No such file or
> directory
>
>
> It doesn't really matter what the kernel returns.  The shell should do its
> job and at least the RHEL/Fedora version does it for a long time now.

That should be pushed upstream then.

Olaf
