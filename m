Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab1DBL22 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 07:28:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43108 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752815Ab1DBL21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 07:28:27 -0400
Date: Sat, 2 Apr 2011 12:28:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Len Brown <lenb@kernel.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, x86@kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 04/18] x86 idle: EXPORT_SYMBOL(default_idle, pm_idle)
 only when APM demands it
Message-ID: <20110402122857.5fb7d2b7@lxorguk.ukuu.org.uk>
In-Reply-To: <dba24a423948935d0a0c1eb32414a476f3f90e02.1301724243.git.len.brown@intel.com>
References: <alpine.LFD.2.02.1104010020280.2797@x980>
	<1301725380-10579-1-git-send-email-lenb@kernel.org>
	<dba24a423948935d0a0c1eb32414a476f3f90e02.1301724243.git.len.brown@intel.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 02 Apr 2011 02:22:46 -0400
Len Brown <lenb@kernel.org> wrote:

> From: Len Brown <len.brown@intel.com>
> 
> In the long run, we don't want default_idle() or (pm_idle)() to
> be exported outside of process.c.  Start by not exporting them
> to modules, unless the APM build demands it.

Pointless added complexity. Why are you so determined to minimise this -
it makes no odds to anyone.
