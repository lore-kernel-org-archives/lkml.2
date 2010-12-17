Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab0LQE26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 23:28:58 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:48328 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab0LQE2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 23:28:55 -0500
From: Miles Bader <miles@gnu.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        Pekka Enbeerg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: x86: A fast way to check capabilities of the current cpu
References: <alpine.DEB.2.00.1012151404070.21102@router.home>
	<20101215125626.25f7d648.akpm@linux-foundation.org>
	<4D092D15.7030700@zytor.com>
	<AANLkTimhdmWGhxW9qnFWYxiVDManH4XG4RqTLJb_Fdbk@mail.gmail.com>
	<4D093580.9000303@zytor.com> <buowrnakze2.fsf@dhlpc061.dev.necel.com>
	<AANLkTim+cbxPxgS+13anHQRdN42uLci6z48hbiyWFdaV@mail.gmail.com>
	<buooc8mko3x.fsf@dhlpc061.dev.necel.com> <4D0A3267.40300@zytor.com>
System-Type: x86_64-unknown-linux-gnu
Blat: Foop
Date: Fri, 17 Dec 2010 13:26:33 +0900
In-Reply-To: <4D0A3267.40300@zytor.com> (H. Peter Anvin's message of "Thu, 16
	Dec 2010 07:38:15 -0800")
Message-ID: <buolj3pja86.fsf@dhlpc061.dev.necel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:
> The alternatives are equivalent when used in the common context.  Your
> examples are bogus, because they don't account for the
> __builtin_constant_p().

Ah, true ... :}

-miles

-- 
Abstainer, n. A weak person who yields to the temptation of denying himself a
pleasure. A total abstainer is one who abstains from everything but
abstention, and especially from inactivity in the affairs of others.
