Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab1GCVYE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 17:24:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42105 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751069Ab1GCVYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 17:24:01 -0400
Date: Sun, 3 Jul 2011 22:25:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vasiliy Kulikov <segoon@openwall.com>, solar@openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        kernel-hardening@lists.openwall.com,
        Randy Dunlap <rdunlap@xenotime.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [RFC] ipc: introduce shm_rmid_forced sysctl
Message-ID: <20110703222539.7d872051@lxorguk.ukuu.org.uk>
In-Reply-To: <20110703193808.GA17797@elte.hu>
References: <20110622152514.GA9521@albatros>
	<20110629151436.9be479fb.akpm@linux-foundation.org>
	<20110701112534.GG20990@elte.hu>
	<20110701113533.GA19945@albatros>
	<20110701120453.GA28008@elte.hu>
	<20110701151827.7061dcda@lxorguk.ukuu.org.uk>
	<20110703193808.GA17797@elte.hu>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a simple extension of the OOM killer being able to ... kill 
> things on OOM, ok? 'to kill' implies 'to break'.

If you do it on the OOM killer then yes that aspect makes sense. The real
problem is that Linux has shipped a broken default for the past ten years.

The number of times I have to explain to industrial and business
customers that Linux doesn't suck but the defaults are stupid is
astounding, and they then wonder why either the authors or their vendor is
a complete and utter moron.

But yes from an OOM perspective killing an unattached SHM segment makes
as much sense as killing anything else.

Alan
