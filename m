Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab2GaQbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:31:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48446 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab2GaQbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:31:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120731103724.20515.60334.stgit@zurg>
References: <20120731103724.20515.60334.stgit@zurg>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 31 Jul 2012 09:31:27 -0700
X-Google-Sender-Auth: Hv0qQ38b-JWSTrdT6zmzLoNCytE
Message-ID: <CA+55aFxxCUOd0ec36mnVB1a93UvOuqsTLOPpJGMsZ2ChudwE1Q@mail.gmail.com>
Subject: Re: [PATCH RESEND v3 00/10] mm: vma->vm_flags diet
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 3:41 AM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
>
> This patchset kills some VM_* flags in vma->vm_flags,
> as result there appears five free bits.

All of these patches make sense and look good to me. I assume I'll get
this through Andrew for 3.7?

Andrew, you can consider them all ack'ed.

               Linus
