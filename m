Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab1BBLPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 06:15:12 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39513 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753750Ab1BBLPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 06:15:11 -0500
Date: Wed, 2 Feb 2011 11:15:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Simon Braunschmidt <sb@emlix.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: Handling multiple watchdogs
Message-ID: <20110202111516.0154bb4a@lxorguk.ukuu.org.uk>
In-Reply-To: <20090722185232.GK2155@infomag.iguana.be>
References: <4A672B97.1070704@emlix.com>
	<20090722171920.505ffc4b@lxorguk.ukuu.org.uk>
	<20090722185232.GK2155@infomag.iguana.be>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1) make sure that we have the new watchdog core infrastructure going in for 2.6.32.
> This new core integrates the common code that we use over and over again. I once
> wrote code for it and then Alan had different ideas and thoughts and wrote his updated
> code. I reviewed that and I am changing some small bits so that we will have the new

What is the status of this ? I was thinking it had been a while but it
seems to be 18 months ago..

Alan


