Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab2JOXFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:05:11 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40419 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab2JOXFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:05:10 -0400
Date: Tue, 16 Oct 2012 00:10:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Mikko C." <mikko.cal@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel panic on CentOS
Message-ID: <20121016001007.35aa5bbb@pyramind.ukuu.org.uk>
In-Reply-To: <507C66E0.6070802@gmail.com>
References: <507C66E0.6070802@gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2012 21:41:20 +0200
"Mikko C." <mikko.cal@gmail.com> wrote:

> Hi,
> we keep getting kernel panics on our CentOS 6.3 server, running about 40 
> KVM virtual machines.
> 
> Here's the screenshot of the trace: http://i.imgur.com/yaRyF.png
> 
> # uname -a
> Linux srv010 2.6.32-71.el6.x86_64 #1 SMP Fri May 20 03:51:51 BST 2011 
> x86_64 x86_64 x86_64 GNU/Linux
> 
> CPU is Intel i7-2600K with 32GB DDR3 ram.
> 
> If there's any more info we can provide, please let me know.

You are in the wrong place - the Red Hat enterprise kernels deviate a lot
from upstream and are very old. Really you need to go back to the Centos
community with it.

Alan
