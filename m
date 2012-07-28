Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab2G1RsS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 13:48:18 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51452 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab2G1RsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 13:48:17 -0400
Date: Sat, 28 Jul 2012 11:11:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 2/4] x86 idle APM: delete apm_cpu_idle()
Message-ID: <20120728111148.39ff7230@ultron>
In-Reply-To: <f8c928c1d43f5c4d1342bd05ca29c8ea788726b8.1343428708.git.len.brown@intel.com>
References: <1343428975-3897-1-git-send-email-lenb@kernel.org>
	<f8c928c1d43f5c4d1342bd05ca29c8ea788726b8.1343428708.git.len.brown@intel.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2012 18:42:53 -0400
Len Brown <lenb@kernel.org> wrote:

> From: Len Brown <len.brown@intel.com>
> 
> The APM idle feature to call into the BIOS
> is known to break some machines, and it has dubious benefit
> on the (decades old) machines it doesn't break.

You mean "doesn't fit my current plan" I think. I see almost no bugzilla
APM reports. It's been solid for years.

It makes a big difference on older systems as it drops the clock. If we
are going to drop this we should probaly also drop APM support entirely
and 386/486 support.

If not IMHO it should stay. Various embedded platforms are still using
ancient hardware setups.

This is a small stable piece of code that has required no maintainance in
years

Furthermore we have a feature removal process. Mark it down to be removed
in July 2013 if there are no objections, and then wait as per proper
process.

NAK

Alan


