Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab1FQNF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 09:05:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49693 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758568Ab1FQNF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 09:05:27 -0400
Date: Fri, 17 Jun 2011 14:07:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Diego Viola <diego.viola@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Please help us resolve the shutdown problem that is affecting
 our computers
Message-ID: <20110617140740.23a8b227@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTinqxc868E2H1LxeFbsAsdHg2dLNjA@mail.gmail.com>
References: <BANLkTin9NXs1M9ud9Kqtp9cKGzY6AKnMpQ@mail.gmail.com>
 <BANLkTinqxc868E2H1LxeFbsAsdHg2dLNjA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011 08:12:12 -0400
Diego Viola <diego.viola@gmail.com> wrote:

> Any idea please?

I think you are under the mistaken impression this is a support list -
it's not. It's also not a list that deals with networking much but with
co-ordinating kernel patches and merges.

As it says in the driver source

Contacts:
e1000-devel Mailing List <e1000-devel@lists.sourceforge.net>

Although if isn't a recent kernel you may be better off going via your
vendor (particularly for things like SLES, Centos, RHEL etc which deviate
a lot from the mainstream)

Alan
