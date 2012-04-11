Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517Ab2DKWQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 18:16:41 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47143 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933457Ab2DKWQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 18:16:40 -0400
Date: Wed, 11 Apr 2012 23:18:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Jackie Li <yaodong.li@intel.com>,
        jim liu <jim.liu@intel.com>, trivial@kernel.org,
        dri-devel@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] gma500: Don't needlessly include version.h in
 mdfld_dsi_output.h
Message-ID: <20120411231846.29747a08@pyramind.ukuu.org.uk>
In-Reply-To: <alpine.LNX.2.00.1204120002390.2137@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204120002390.2137@swampdragon.chaosbits.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012 00:05:29 +0200 (CEST)
Jesper Juhl <jj@chaosbits.net> wrote:

> drivers/gpu/drm/gma500/mdfld_dsi_output.h does not need to
> '#include <linux/version.h>' - so don't.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: Alan Cox <alan@linux.intel.com>
