Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab2H0Wp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 18:45:27 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34934 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2H0Wp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 18:45:26 -0400
Date: Mon, 27 Aug 2012 23:50:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Marcin Juszkiewicz <marcin@juszkiewicz.com.pl>
Cc: linux-kernel@vger.kernel.org, richard.purdie@linuxfoundation.org,
        Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>
Subject: Re: [PATCH] Drop ProGear backlight driver
Message-ID: <20120827235007.38db181a@pyramind.ukuu.org.uk>
In-Reply-To: <1346079285-13712-1-git-send-email-marcin@juszkiewicz.com.pl>
References: <1346079285-13712-1-git-send-email-marcin@juszkiewicz.com.pl>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2012 16:54:45 +0200
Marcin Juszkiewicz <marcin@juszkiewicz.com.pl> wrote:

> From: Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>
> 
> This driver was for ProGear webpad device which was produced in
> 2000/2001 and is not available on a market. I no longer have this
> hardware so can not even check how Linux works on it.
> 
> Signed-off-by: Marcin Juszkiewicz <marcin@juszkiewicz.com.pl>

This really ought to go out via staging for a couple of releases so
someone who cares can speak up.

Alan

