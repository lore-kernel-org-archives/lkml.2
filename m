Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab1JDKn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 06:43:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49355 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755901Ab1JDKnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 06:43:23 -0400
Date: Tue, 4 Oct 2011 11:43:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ganesh Karuppur Rajagopalan <ganesh.kr356@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pallav Bose <pallavbose@gmail.com>
Subject: Re: Queuing multiple task_struct structures?
Message-ID: <20111004114314.45d8ac5f@lxorguk.ukuu.org.uk>
In-Reply-To: <CAFXDVL8EhVUo9jom_DGEmbSzjA5bUf0iYzGyh-K3AeytL-=VSw@mail.gmail.com>
References: <CAFXDVL8EhVUo9jom_DGEmbSzjA5bUf0iYzGyh-K3AeytL-=VSw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> thread which uses the ioctl() system call to send a userspace buffer
> to my block device driver. Once I queue up multiple task_structs, I
> would like to keep them on the queue until a particular condition is
> met (i.e., the buffer has been written down to the disk).

We already have a perfectly usable raw I/O interface set, why not just
use those ?

Alan
