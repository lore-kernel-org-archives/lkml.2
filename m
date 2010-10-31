Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab0JaLgQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 07:36:16 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45955 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab0JaLgN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 07:36:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gRyNJoKi1ykszQ/QzPk9S3U8Bl6hT+CW605Q0473Ptz0yl1vG/MOrStYlQ26LW4SU/
         DnVYHhRtQhXjT43hkYd9dk3z4ZAHBqYR6ApcAy3a3j8qH13ElcCtAE1s/1Zplb+uND0K
         ZVIWmB7cKftD1qC/y9qTZViH+JhXeDkUBR1Z8=
MIME-Version: 1.0
In-Reply-To: <20101027082702.c65a0d22.randy.dunlap@oracle.com>
References: <1288157312-10441-1-git-send-email-ying.huang@intel.com>
	<1288174050.15336.1507.camel@twins>
	<20101027082702.c65a0d22.randy.dunlap@oracle.com>
Date: Sun, 31 Oct 2010 19:36:12 +0800
Message-ID: <AANLkTinp48sY7HPOu4JgnSKhMpo1j0e71n2TeECn4wLv@mail.gmail.com>
Subject: Re: [PATCH -v3 0/8] ACPI, APEI patches for 2.6.37
From: huang ying <huang.ying.caritas@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Huang Ying <ying.huang@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, "Luck, Tony" <tony.luck@intel.com>,
        BorislavPetkov <petkovbb@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Randy,

On Wed, Oct 27, 2010 at 11:27 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Looks like you also have not addressed this reported build error:
>  http://lkml.org/lkml/2010/10/25/440

Sorry for late, busy in traveling recently. I will fix the issue in
the next version.

Best Regards,
Huang Ying
