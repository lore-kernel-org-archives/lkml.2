Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab2DEU13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 16:27:29 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:33620 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab2DEU12 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 16:27:28 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA4V-u9fVpJYZ==wB+uxxSExbbBk6O60BM+b-v9Mfk+8vQ@mail.gmail.com>
References: <4F7A3315.501@goop.org>
	<CA+5PVA4V-u9fVpJYZ==wB+uxxSExbbBk6O60BM+b-v9Mfk+8vQ@mail.gmail.com>
Date: Thu, 5 Apr 2012 16:27:26 -0400
Message-ID: <CA+5PVA50Bz2BtDw77yBvQpc9BxGZqyp0_4JeZUY-E_QB0mFZsA@mail.gmail.com>
Subject: Re: [PATCH] Use correct byte-sized register constraint in __xchg_op()
From: Josh Boyer <jwboyer@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Reitmayr <treitmayr@devbase.at>, leigh123linux@googlemail.com,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 3, 2012 at 8:37 PM, Josh Boyer <jwboyer@gmail.com> wrote:
> On Mon, Apr 2, 2012 at 7:15 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>> x86-64 can access the low half of any register, but i386 can only do
>> it with a subset of registers.  'r' causes compilation failures on i386,
>> but 'q' expresses the constraint properly.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
>> Reported-by: Leigh Scott <leigh123linux@googlemail.com>
>> Tested-by: Thomas Reitmayr <treitmayr@devbase.at>
>
> This should be CC'd to stable, given the bug shows up in 3.3, right?

Er.. this patch seems to have been lost in limbo.  Is anyone following
up on it?

josh
