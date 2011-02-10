Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab1BJNpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 08:45:04 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43016 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756067Ab1BJNpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 08:45:02 -0500
Date: Thu, 10 Feb 2011 13:48:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oren Weil <oren.jer.weil@intel.com>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        david@woodhou.se, david.woodhouse@intel.com
Subject: Re: [RFC PATCH 03/13] Intel(R) MEI Driver
Message-ID: <20110210134825.2fd0dc6d@lxorguk.ukuu.org.uk>
In-Reply-To: <b7da2f$qd3ne6@fmsmga001.fm.intel.com>
References: <b7da2f$qd3ne6@fmsmga001.fm.intel.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 Feb 2011 01:55:03 -0800
Oren Weil <oren.jer.weil@intel.com> wrote:

> diff --git a/drivers/char/mei/Makefile b/drivers/char/mei/Makefile
> new file mode 100644
> index 0000000..a9ac1cb
> --- /dev/null
> +++ b/drivers/char/mei/Makefile

Just a note for the final submission- the kernel should always build
through a series of changes and we rely on this for git bisect so submit
the Makefile and Kconfig as the last patches that way it works out nicely.
