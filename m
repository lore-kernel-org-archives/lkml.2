Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab2DIJfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 05:35:13 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39007 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab2DIJfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 05:35:12 -0400
Date: Mon, 9 Apr 2012 10:37:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Xin Tong <xerox.time.tech@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: oostore on x86
Message-ID: <20120409103745.487fa6f1@pyramind.ukuu.org.uk>
In-Reply-To: <20120408232728.GA29407@redhat.com>
References: <CALKntY1V2nELdTOSVpm1PwVmxm1pxtGdvs8tUyNA1R=c9K8pcA@mail.gmail.com>
	<4F820804.2040302@zytor.com>
	<20120408232728.GA29407@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've suggested just removing that code in the past a few times.
> Even if it does still work, anyone complaining about performance loss
> of a modern kernel on something of that era can't be taken seriously.

I'm not sure removing it makes sense given what a tiny spec of code is
involved. Also in practice most of the same bits are actually used with
different fencing operators on PPro for errata and on PIII and higher for
temporal stores. Of the tree tiny changes it causes two are identical to
PPro...

Alan

