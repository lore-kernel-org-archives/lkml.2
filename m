Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab0J0KHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:07:55 -0400
Received: from canuck.infradead.org ([134.117.69.58]:41870 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab0J0KHx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:07:53 -0400
Subject: Re: [PATCH -v3 0/8] ACPI, APEI patches for 2.6.37
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        BorislavPetkov <petkovbb@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1288157312-10441-1-git-send-email-ying.huang@intel.com>
References: <1288157312-10441-1-git-send-email-ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 27 Oct 2010 12:07:30 +0200
Message-ID: <1288174050.15336.1507.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 13:28 +0800, Huang Ying wrote:
> v3:
> 
> - Rework lock-less memory allocator and lock-less list.
> 
> v2:
> 
> - Some minor changes according to Andi's comments.
> 
> [PATCH -v3 1/8] ACPI, APEI, Add ERST record ID cache
> [PATCH -v3 2/8] lib, Make gen_pool memory allocator lock-less
> [PATCH -v3 3/8] lib, Add lock-less NULL terminated single list
> [PATCH -v3 4/8] Hardware error device core
> [PATCH -v3 5/8] Hardware error record persistent support
> [PATCH -v3 6/8] ACPI, APEI, Use ERST for hardware error persisting before panic
> [PATCH -v3 7/8] ACPI, APEI, Report GHES error record with hardware error device core
> [PATCH -v3 8/8] ACPI, APEI, Generic Hardware Error Source POLL/IRQ/NMI notification type support

You forgot to CC all people who participated in the previous discussion.

You seem to have forgotten to address the high-level feedback given by
the x86 maintainers.

All you've done is decreased the arch/x86/ footprint of the patch
series, but neither you nor Andi have addressed the technical arguments
against adding this ABI.

Nor have you engaged in conversation with the other EDAC people on how
to extend the existing interface, or even work towards creating
something new that would cater to all interested parties.

Not charmed at all by your attitude.
