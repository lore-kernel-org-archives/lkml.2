Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab2DRTDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 15:03:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41314 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab2DRTDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 15:03:34 -0400
Message-ID: <4F8F0FF4.7010701@zytor.com>
Date: Wed, 18 Apr 2012 12:03:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/x32] x32: Fix alignment fail in struct compat_siginfo
References: <1329696488-16970-1-git-send-email-hpa@zytor.com> <tip-31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4@git.kernel.org> <CAMe9rOqF6Kh6-NK7oP0Fpzkd4SBAWU+G53hwBbSD4iA2UzyxuA@mail.gmail.com> <4F8EFE4D.2040201@zytor.com> <CAMe9rOpfPQghra1PQTUwsFOvjgNpzFDEGS5=BbFBjn=HZGL93g@mail.gmail.com> <4F8F0385.5090901@zytor.com> <CAMe9rOq7LduF4aLPe9qatedxps4WPCgOHTD=E_Lje4_tu6tyZw@mail.gmail.com> <4F8F0614.9010604@zytor.com> <CAMe9rOqBd29LKB==NaKscpedRMR1uL_ZhHqSw1HQj-3_d9PSCw@mail.gmail.com>
In-Reply-To: <CAMe9rOqBd29LKB==NaKscpedRMR1uL_ZhHqSw1HQj-3_d9PSCw@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at asm/siginfo.h it already has a bunch of __ARCH_SI_*_T macros,
so I guess adding an __ARCH_SI_CLOCK_T would not be out of place.

The whole misaligned union in this structure is a complete facepalm, but
there isn't much we can do about it now.

	-hpa

