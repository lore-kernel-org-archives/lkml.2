Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab1HCMpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 08:45:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33995 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755492Ab1HCMps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 08:45:48 -0400
Date: Wed, 3 Aug 2011 13:48:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mrst_pmu: driver for Intel Moorestown Power
 Management Unit
Message-ID: <20110803134851.36995d0c@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.02.1108021916430.25237@x980>
References: <alpine.LFD.2.02.1107122328180.4502@x980>
	<20110713105105.63e2fbcb@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.02.1108011116160.23581@x980>
	<alpine.LFD.2.02.1108021916430.25237@x980>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This driver is essentially platform-speciif idle code.
> It has been in linux-next via my idle-test tree,
> and I can push it via that tree route w/ appropriate acks.

Looks good to me

Acked-by: Alan Cox <alan@linux.intel.com>

