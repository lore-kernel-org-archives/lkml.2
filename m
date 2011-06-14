Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab1FNJd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 05:33:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37041 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755726Ab1FNJd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 05:33:57 -0400
Date: Tue, 14 Jun 2011 10:35:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, sre@debian.org,
        linus.walleij@linaro.org, govindraj.ti@gmail.com,
        pawel.szyszuk@stericsson.com, sjur.brandeland@stericsson.com,
        peter_henn@gmx.de
Subject: Re: [RFC PATCHv5 0/7] HSI framework and drivers
Message-ID: <20110614103548.3b336dac@lxorguk.ukuu.org.uk>
In-Reply-To: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
References: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011 16:38:37 +0300
Carlos Chinea <carlos.chinea@nokia.com> wrote:

> Hi !
> 
> Here you have the fifth round of the HSI framework patches.

Looks good to me - only other oddity I found is to build hsi_char on x86
you need slab.h before kmemleak.h or the build errors
