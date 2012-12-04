Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab2LDImA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 03:42:00 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51498 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab2LDIl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 03:41:59 -0500
Date: Tue, 4 Dec 2012 08:47:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Woody Wu <narkewoody@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why a host not ping-able?
Message-ID: <20121204084723.4b992d49@pyramind.ukuu.org.uk>
In-Reply-To: <slrnkbr59r.us1.narkewoody@zuhnb712.local.com>
References: <slrnkbr59r.us1.narkewoody@zuhnb712.local.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2012 06:17:25 +0000 (UTC)
Woody Wu <narkewoody@gmail.com> wrote:

> Hi, list
> 
> I am not sure this has something with kernel.  But the system I just
> generated cannot be reached from ping.  It can ping outside, but if I
> ping it from outside, I just get "Destination Host Unreachable".
> 
> I think there is not firewall in between, and the two host in the test
> are in the same ethernet sub network.  Is that possible the strange
> behavior caused by somehow misconfigured kernel?

Very unlikely. More likely you have a routing problem somewhere. tcpdump
or similar network monitoring tools are probably what you need.
