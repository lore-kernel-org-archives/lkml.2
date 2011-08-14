Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab1HNP1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 11:27:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50584 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab1HNP1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 11:27:32 -0400
Date: Sun, 14 Aug 2011 17:27:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Solar Designer <solar@openwall.com>, Andi Kleen <andi@firstfloor.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [RFC] x86: restrict pid namespaces to 32 or 64 bit syscalls
Message-ID: <20110814152729.GU5782@one.firstfloor.org>
References: <20110812150304.GC16880@albatros> <4E45884B.8030303@zytor.com> <20110813062246.GC3851@albatros> <36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com> <m2ei0olnua.fsf@firstfloor.org> <632d03b0-6725-431e-b100-13f5046b03e9@email.android.com> <20110814092028.GB14293@openwall.com> <01ba0cce-d28e-473e-be3a-7d3c8f185681@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01ba0cce-d28e-473e-be3a-7d3c8f185681@email.android.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> i386 vs x86-64 vs x32 is just one of many axes along which syscalls can be restricted (and for that matter, one axis if backward compatibility), and it does not make sense to burden the code with ad hoc filters.  Designing a general filter facility which can be used to restrict any container to the subset of system calls it actually needs would make more sense, no?

I believe this is already in the newer versions of seccomp.

-Andi
