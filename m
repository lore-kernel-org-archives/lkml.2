Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1A1SEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 13:04:16 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58861 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab1A1SEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 13:04:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=umRs0el7h6ygZAchyP+shCh7kpgeKM96SZoZP12W3Vpw1UkO4SFM9/L7C5PFD00A0q
         fJ0jk2S6p3QQedECxdDk4SonHMuEysbWEQLE6/gq7Uz0b2sDEEW+diLTgu0N7mE+EpoH
         tpFuOF87jiITCxfnxqH7tKPZbWZQ+LGrQEtpk=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1101281839390.31804@localhost6.localdomain6>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
	<20110128165455.GA18194@elte.hu>
	<alpine.LFD.2.00.1101281839390.31804@localhost6.localdomain6>
Date: Fri, 28 Jan 2011 20:04:13 +0200
Message-ID: <AANLkTinm53a1BzLu6JCBdgOpkHw9MOg2H4gD7xiRyvOh@mail.gmail.com>
Subject: Re: [PATCHSET] ptrace,signal: group stop / ptrace updates
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>, roland@redhat.com,
        oleg@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 7:41 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 28 Jan 2011, Ingo Molnar wrote:
>> See that '^C^C' line? That is where i had to do Ctrl-C twice.
>>
>> It only fails here about once every 10 times, so it's very rare. I have a stock F14
>> system running on that box, with the very latest .38 based kernel.
>
> Tripped over the refuse ^C thing today twice. Had to kill a kernel
> build from another shell. It just happily displayed ^C and never
> stopped. That happens once in a while and I have no idea either how to
> debug that.

cc: Mathieu

Use lttng ?
