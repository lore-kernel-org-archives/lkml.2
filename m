Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab1JLA5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 20:57:38 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41141 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1JLA5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 20:57:37 -0400
MIME-Version: 1.0
In-Reply-To: <20111006190526.GA13883@redhat.com>
References: <20111006190526.GA13883@redhat.com>
Date: Tue, 11 Oct 2011 20:57:36 -0400
Message-ID: <CAOULuOYy3HKbmFa8e9MFDCrduQKZhzgZ2CTskXTWxKCmFNRSRQ@mail.gmail.com>
Subject: Re: RFC: virtualbox tainting.
From: Parag Warudkar <parag.lkml@gmail.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 6, 2011 at 3:05 PM, Dave Jones <davej@redhat.com> wrote:
> The number of bug reports we get from people with virtualbox loaded are
> truly astonishing.  It's GPL, but sadly that doesn't mean it's good.
> Nearly all of these bugs look like random corruption. (corrupt linked lists,
> corrupt page tables, and just plain 'weird' crashes).
>
> This diff adds tainting to the module loader to treat it as we do with stuff
> from staging/ (crap). With this tainting in place, automatic bug filing tools
> can opt out of automatically filing kernel bugs, and inform the user to file
> bugs somewhere more appropriate.
>

Why can't the automatic bug filing tools have a user space list of
offending modules that it can use to opt out of automatically filing
kernel bugs? May be it can keep that list as part of a file in a
package that can be updated as and when more out of tree modules are
found. This can also be used for all out of tree modules - if module
is not part of standard kernel modules then opt out. I think this can
and should all be done in user space.

If people still report bugs manually may be have bugzilla ask them for
list of modules loaded and run a batch job to scan and close the ones
with blacklisted modules.

Parag
