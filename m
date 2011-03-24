Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab1CXOvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:51:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54079 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750907Ab1CXOvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 10:51:36 -0400
Date: Thu, 24 Mar 2011 14:51:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Petr Pisar <ppisar@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Clean console safely
Message-ID: <20110324145156.1cc0121e@lxorguk.ukuu.org.uk>
In-Reply-To: <20110324141552.GA1291@dhcp-0-146.brq.redhat.com>
References: <1300960611-4820-1-git-send-email-ppisar@redhat.com>
	<20110324102431.5e017efe@lxorguk.ukuu.org.uk>
	<20110324141552.GA1291@dhcp-0-146.brq.redhat.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm searching for a clear display feature which preserves configuration.
> I read console_codes(4), console_ioctl(4), and now the VT520 documentation and
> I did not find any existing control code. The most close seems ED J for me.

Seems reasonable to me on that basis.


> 
> -- Petr


-- 
--
	"Alan, I'm getting a bit worried about you."
				-- Linus Torvalds
