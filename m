Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab2EAMrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 08:47:07 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38395 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab2EAMrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 08:47:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAPa8GCBdVXx+iF9QAoURWchAY0avesYNwbQs_Do1Kn6Pyx+8+Q@mail.gmail.com>
References: <CANkdjvZinRvHYPKLCFsd6z3FXgM4ScS1Ar9OjO3s1SLDFnridw@mail.gmail.com>
	<CAPa8GCBdVXx+iF9QAoURWchAY0avesYNwbQs_Do1Kn6Pyx+8+Q@mail.gmail.com>
Date: Tue, 1 May 2012 05:47:04 -0700
X-Google-Sender-Auth: WkBLcVZB8jfWt5SgdMhwyWxGCe8
Message-ID: <CANkdjvZJU5Z3eLk2_Orz+J0OJ6z0=ui6uUJUPwqh-dnjNPk+ZQ@mail.gmail.com>
Subject: Re: read() syscall slowing down due to other threads?
From: George Porter <gmporter@cs.ucsd.edu>
To: Nick Piggin <npiggin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 11:40 PM, Nick Piggin <npiggin@gmail.com> wrote:
> It could be memory or coherency traffic that's causing a slowdown across
> the system?
>
> Could a dynamic core frequency / thermal throttling explain any of the
> slowdown?

Thanks for these suggestions.  I checked the BIOS, and indeed it was
set to "Hybrid power/performance."  I just reset the server to "Static
high performance" which I believe turns off processor frequency power
optimizations.  I'll re-run our workload and see if that has an
effect.

Thanks, George
