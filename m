Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab0GYKoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 06:44:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34188 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752234Ab0GYKoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 06:44:17 -0400
Date: Sun, 25 Jul 2010 11:55:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Javier Martinez Canillas <martinez.javier@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, mrst: remove unused mrst_identify_cpu()
Message-ID: <20100725115524.76138396@lxorguk.ukuu.org.uk>
In-Reply-To: <4C4BC5ED.3030104@zytor.com>
References: <1280033438.2419.5.camel@lenovo>
	<4C4BC5ED.3030104@zytor.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jul 2010 22:04:45 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Jacob, is this obsolete or something that will be needed in future versions?
> 
> It seems that either __mrst_cpu_chip should be killed off, or read-only
> users should be using the inline instead of __mrst_cpu_chip directly.

And how is the inline going to access the variable if the variable isn't
global ...

Alan
