Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab1DBLk3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 07:40:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54732 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752306Ab1DBLk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 07:40:26 -0400
Date: Sat, 2 Apr 2011 12:40:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Len Brown <lenb@kernel.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 16/18] 2.6.40: x86 idle APM: remove deprecated
 apm_cpu_idle()
Message-ID: <20110402124054.49c3a3f4@lxorguk.ukuu.org.uk>
In-Reply-To: <5d9716021b20302ece48fd486bbad9bcb2502353.1301724243.git.len.brown@intel.com>
References: <alpine.LFD.2.02.1104010020280.2797@x980>
	<1301725380-10579-1-git-send-email-lenb@kernel.org>
	<5d9716021b20302ece48fd486bbad9bcb2502353.1301724243.git.len.brown@intel.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 02 Apr 2011 02:22:58 -0400
Len Brown <lenb@kernel.org> wrote:

> From: Len Brown <len.brown@intel.com>
> 
> There is some doubt whether the APM idle feature
> to call into the BIOS from the idle loop is reliable.
> Certainly it was known to fail on some machines,

And it was known to work on lots - a point that despite repeated
reminding you seem keen to ignore.

The fundamental problem I have with this patch set is this

You've provided no architectural overall justification for all this
effort. What is the big picture around your crusade here ? What is the
grand plan ?

> but more importantly, APM machines have not shipped
> for a decade and so finding machines to test the code
> is problematic.

So don't test it - if it's wrong someone will let you know, believe me 8)

And 2.6.40 is far too soon - it takes about a year for stuff to rattle
through to leading edge distro users in bulk

Alan

