Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab1CBK6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:58:38 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35529 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199Ab1CBK6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:58:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=tQfJw4thJOMhZGxgZS4I4JLiMPwtY64/Xlo2hTS3nmZpKkuQEgnMxVqVvVusXLqvgk
         Uu+vDCQfhSEvJi/QQdor7NJ0ekkL1wNvTtUrnBpotfNJHV4LDuhzCn1BH1+clgn43SXN
         rDDS9iFIrSTBDSscOrLzaBVYoHUqd9ai6Y7uQ=
MIME-Version: 1.0
In-Reply-To: <20110302072848.GB19669@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org> <20110301190638.GA12196@host1.dyn.jankratochvil.net>
 <AANLkTiknaHNADRa3R4Tefg2TGuFmKPZY-_08_krFiNFF@mail.gmail.com> <20110302072848.GB19669@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 2 Mar 2011 11:58:16 +0100
Message-ID: <AANLkTinThbP-DsNu=oxfvMS6TaaJ_tBDX8rShc0zFy76@mail.gmail.com>
Subject: Re: [RFC] Proposal for ptrace improvements
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 8:28 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Tue, Mar 01, 2011 at 11:14:14PM +0100, Denys Vlasenko wrote:
>> There may be reasons to have PTRACE_SEIZE operation split like that.
>> For one, this allows debugger to do PTRACE_CONT, and later issue
>> PTRACE_INTERRUPT to stop the tracee again. PTRACE_INTERRUPT stop may
>> be better for some scenarios where debugger wants to make the stop
>> invisible to the parent, or when debugger wants to stop just one
>> thread of the process.
>
> PTRACE_SEIZE can be used like PTRACE_INTERRUPT.  It works whether the
> tracee is attached or not.

Makes sense.

-- 
vda
