Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab1HCQWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 12:22:39 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40541 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab1HCQW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 12:22:26 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1108031214470.22067@x980>
References: <cover.1312386029.git.luto@mit.edu> <5bec80947da3fb72f2f18fbe6d924a69f83fbed9.1312386029.git.luto@mit.edu>
 <alpine.LFD.2.02.1108031214470.22067@x980>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 3 Aug 2011 12:22:04 -0400
X-Google-Sender-Auth: 6WgvgGkH4VXsjPLXSTtWPU8hrpE
Message-ID: <CAObL_7GuAmzyjo5AmYxbTeiAqFtVk1N+opzWEzwJu8Mgrvts7g@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86: Enable monitor/mwait on Intel if BIOS hasn't already
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 3, 2011 at 12:15 PM, Len Brown <lenb@kernel.org> wrote:
> On Wed, 3 Aug 2011, Andy Lutomirski wrote:
>
>> I have a Sandy Bridge machine with an Intel BIOS that enables
>> monitor/mwait on all but the boot CPU.  With this patch, intel_idle
>> works.
>
> What machine has this BIOS bug, and are you running
> the latest version of the BIOS?

Intel DQ67SW, version SWQ6710H.86A.0051.2011.0413.1154.  This is not
quite up-to-date -- I'll test a newer BIOS.

(Enabling monitor/mwait on some but not all CPUs is obnoxious, too.  I
think it's just dumb luck that Linux notices at all and doesn't
crash.)

--Andy
