Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab0LPKhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:37:36 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:50201 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab0LPKhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:37:34 -0500
From: Miles Bader <miles@gnu.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
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
System-Type: x86_64-unknown-linux-gnu
Blat: Foop
Date: Thu, 16 Dec 2010 19:29:06 +0900
In-Reply-To: <AANLkTim+cbxPxgS+13anHQRdN42uLci6z48hbiyWFdaV@mail.gmail.com>
	(Miguel Ojeda's message of "Thu, 16 Dec 2010 11:17:25 +0100")
Message-ID: <buooc8mko3x.fsf@dhlpc061.dev.necel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> writes:
>>> If they aren't, and are stored in a variable for whatever reason, then
>>> the || form will generate additional instructions to booleanize the
>>> value for no good reason.
>
> I think hpa was talking about some code where gcc can not optimize out
> the assignment (e.g. volatile, complex code, using the int outside
> conditional expressions, etc.).

Sure, but that seems to assume that the alternatives are otherwise
equivalent in the common case, when used in a boolean context.

If that's not true then one risks pessimizing the common case to make an
uncommon case more efficient.

-Miles

-- 
Suburbia: where they tear out the trees and then name streets after them.
