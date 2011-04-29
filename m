Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760774Ab1D2SAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:00:00 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63054 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894Ab1D2R76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:59:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=r3niB9a44S5x1/+ROnFBD+um3yy3sKoisvilqSbqo34GeJTCgfa0J+oojbc9lLpGPq
         ZLfZXfzokT8MYZ9+SrdsSZ99DIXR3ecLGAceRRSDxSZr6iB9oC2AjdZw44wGFvE/iq8v
         f5uq10kFl2NfnEkAcoU4xiUwhfnYtsbUOftbc=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1104291341510.23685@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu>
	<BANLkTimjmYUJMGw0aB+w+E76H+kxSpqFZg@mail.gmail.com>
	<20110429172525.GA2745@tassilo.jf.intel.com>
	<BANLkTim3bojtfeeWsAFx2Gct7LsvGCdn-w@mail.gmail.com>
	<alpine.DEB.2.00.1104291341510.23685@cl320.eecs.utk.edu>
Date: Fri, 29 Apr 2011 20:59:57 +0300
X-Google-Sender-Auth: 9nU6a6Keh0zXL-kK89ypkMJ0q0Q
Message-ID: <BANLkTimhYJ6fbX55z=t4T9bpfe-W0N8nYQ@mail.gmail.com>
Subject: Re: re-enable Nehalem raw Offcore-Events support
From: Pekka Enberg <penberg@kernel.org>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Andi Kleen <ak@linux.intel.com>, torvalds@linux-foundation.org,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vince!

On Fri, 29 Apr 2011, Pekka Enberg wrote:
>> Asking Linus to revert the commit is short-sighted and doesn't solve
>> the problem. Learn to work with the maintainer and save yourself a lot
>> of trouble.

On Fri, Apr 29, 2011 at 8:46 PM, Vince Weaver <vweaver1@eecs.utk.edu> wrote:
> Work "with" Ingo?  That's turned out well so far.  I'm sure certain
> scheduler people could comment here too on where that gets you.

Yeah, that Ingo dude is really impossible to work with (as are most
kernel maintainers)! I've personally been so unfortunate that I've
never had any problems but it must be my bad attitude to working with
other people and actually listening to them. :-(

On Fri, Apr 29, 2011 at 8:46 PM, Vince Weaver <vweaver1@eecs.utk.edu> wrote:
> The kernel I run is "Linux" not "Ingoix".  So I await a comment from Linus
> on this issue.  If it turns out that he's happy with Ingo's work, fine.
> It just means I'll have to start maintaining some perf counter related
> patches out of tree for those of us who actually like having control on
> what we're measuring.

Well, it's not Ingoix but Ingo gets to maintain your ABI long after
you're gone while Linus can just sit back, relax, and have a drink. So
I think it'd be fair to at least _pretend_ you care what Ingo thinks
about perf ABIs, no?

                         Pekka
