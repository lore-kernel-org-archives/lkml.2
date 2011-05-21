Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab1EUPfG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 11:35:06 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58137 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab1EUPfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 11:35:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=E4D0Jn3UOlGcxVqRijO4AuGpTM7zeZo+3y8VRdel4GNJNeGWEF5LNtg6InLFI3q67/
         DNdva9/c5ClcyRfjOpZdTbGJHDF21yuJ3QaD5P9rKY7+RK1n+7HulQ9QER9JEFSCJU8j
         LOkcbVVUPh9xDpYi85rbF4Er7Yd1EkhD1kTU8=
MIME-Version: 1.0
In-Reply-To: <201105211727.35985.arnd@arndb.de>
References: <BANLkTinM_=bAjD59=GiKtTvjLtoOs7KCFA@mail.gmail.com>
	<201105211727.35985.arnd@arndb.de>
Date: Sat, 21 May 2011 08:34:59 -0700
Message-ID: <BANLkTi=tdfG3jpCJQpozpxjBmR7ZicgV9g@mail.gmail.com>
Subject: Re: X32 project status update
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com,
        "H. Peter Anvin" <h.peter.anvin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 8:27 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 21 May 2011 17:01:33 H.J. Lu wrote:
>> This is the x32 project status update:
>>
>> https://sites.google.com/site/x32abi/
>>
>
> I've had another look at the kernel patch. It basically
> looks all good, but the system call table appears to
> diverge from the x86_64 list for no (documented) reason,
> in the calls above 302. Is that intentional?
>
> I can see why you might want to keep the numbers identical,
> but if they are already different, why not use the generic
> system call table from asm-generic/unistd.h for the new
> ABI?

We can sort it out when we start merging x32 kernel changes.


-- 
H.J.
