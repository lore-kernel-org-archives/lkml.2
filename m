Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab1GOXNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 19:13:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59944 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753617Ab1GOXNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 19:13:18 -0400
Date: Sat, 16 Jul 2011 00:15:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Olaf Hering <olaf@aepfle.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dave Airlie <airlied@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 2/2] panic, vt: do not force oops output when
 panic_timeout < 0
Message-ID: <20110716001551.52e817e4@lxorguk.ukuu.org.uk>
In-Reply-To: <1310770401-10739-2-git-send-email-msb@chromium.org>
References: <1310770401-10739-1-git-send-email-msb@chromium.org>
	<1310770401-10739-2-git-send-email-msb@chromium.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> already storing the panic in RAM and are going to reboot immediately, there
> is no benefit in mode switching back to the vc in order to display the panic
> output. The log buffer will get flushed by the console_unblank() call so
> remote management consoles should see all output.

Doesn't seem too unreasonable and its probably a behaviour (although with
netconsole) that a lot of server farms would prefer too.

Acked-by: Alan Cox <alan@linux.intel.com>
