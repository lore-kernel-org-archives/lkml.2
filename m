Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab1HAOJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 10:09:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45215 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752230Ab1HAOJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 10:09:56 -0400
Date: Mon, 1 Aug 2011 15:13:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux, binary blob and binary driver summary for vendors?
Message-ID: <20110801151302.7d56cd0d@lxorguk.ukuu.org.uk>
In-Reply-To: <20110801134212.GS29803@nalle>
References: <20110801134212.GS29803@nalle>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Aug 2011 16:42:12 +0300
Mikko Rapeli <mikko.rapeli@iki.fi> wrote:

> What is a good and also technically detailed summary of the binary blob and
> driver issues with Linux kernel and GPL?
> 
> I'd like to refer a vendor to some documentation regarding this instead
> writing a ton of text with IANAL everywhere.

I would suggest they talk to the Linux Foundation. It's basically a legal
question around derivative works, and that's a lawyer question that tends
to need looking at by lawyers per piece of code.

Aside from that there are technical, marketing and PR things to consider.

Alan
