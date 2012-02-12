Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab2BLERp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 23:17:45 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44035 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab2BLERn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 23:17:43 -0500
MIME-Version: 1.0
In-Reply-To: <m1ipjc3fsk.fsf@fess.ebiederm.org>
References: <tip-d9bc9be89629445758670220787683e37c93f6c1@git.kernel.org>
	<CAE9FiQWRjvu_uNcx_bJXYHeg4D4k6YzHHmSudsq7EyubLi7+nw@mail.gmail.com>
	<m1ipjc3fsk.fsf@fess.ebiederm.org>
Date: Sat, 11 Feb 2012 20:17:43 -0800
X-Google-Sender-Auth: rBJIYZq7sD-zyykW7mlV7M0PA88
Message-ID: <CAE9FiQVLnyRB+pAqi22C5mCbHOOVKxsBhQKaB6P0p9f2LBL8bA@mail.gmail.com>
Subject: Re: [tip:x86/debug] x86/kdump: No need to disable ioapic/ lapic in
 crash path
From: Yinghai Lu <yinghai@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        torvalds@linux-foundation.org, kexec@lists.infradead.org,
        vgoyal@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 11, 2012 at 7:13 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
>> After reverting this commit, kdump is working again.
>>
>> So assume you need to drop this patch.
>
> It sounds like there is a bug in ioapic initialization in the context of
> VT-d.  Where do you fail?
>
before get debug print out from second kernel, the system get reset.

Yinghai
