Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab1JLUy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 16:54:58 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44360 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab1JLUy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 16:54:57 -0400
MIME-Version: 1.0
In-Reply-To: <1318449339.18471.15.camel@knife>
References: <20111006190526.GA13883@redhat.com>
	<CAOULuOYy3HKbmFa8e9MFDCrduQKZhzgZ2CTskXTWxKCmFNRSRQ@mail.gmail.com>
	<1318449339.18471.15.camel@knife>
Date: Wed, 12 Oct 2011 16:54:55 -0400
Message-ID: <CAOULuOYKLirR-_qT8eNbJxX3+nopfPWkkBVES7oyCRH3fH9JrA@mail.gmail.com>
Subject: Re: RFC: virtualbox tainting.
From: Parag Warudkar <parag.lkml@gmail.com>
To: Zan Lynx <zlynx@acm.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 3:55 PM, Zan Lynx <zlynx@acm.org> wrote:
> On Tue, 2011-10-11 at 20:57 -0400, Parag Warudkar wrote:
>
>> If people still report bugs manually may be have bugzilla ask them for
>> list of modules loaded and run a batch job to scan and close the ones
>> with blacklisted modules.
>
> Still report bugs manually? Fedora 15's abrt tool has /never/
> successfully filed a bug for me. It actually is supposed to work? I am
> surprised.

That's another reason not to have this patch in the kernel ;)

I don't know about Fedora, but Ubuntu's bug reporter got a lot better
with 11.10 betas.
The other day it detected i915 GPU hang, collected all files and
successfully reported the bug!

The only catch - it did not properly capure the i915_error_state (all
zeros), which in fairness, might not be the tool's fault.
That and it might need to be made a little more subtle / less annoying.

Parag
