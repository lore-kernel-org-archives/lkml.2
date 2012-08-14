Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab2HNMfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 08:35:42 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45363 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab2HNMfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 08:35:41 -0400
Date: Tue, 14 Aug 2012 13:40:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ajay Garg <ajaygargnsit@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to hack syscall-table, in kernel 2.6+ ?
Message-ID: <20120814134020.367361b5@pyramind.ukuu.org.uk>
In-Reply-To: <CAHP4M8WV64UMor_oU4UNgGx7P0Zet_M3yJrAZaCR+yYQmmeEYw@mail.gmail.com>
References: <CAHP4M8WV64UMor_oU4UNgGx7P0Zet_M3yJrAZaCR+yYQmmeEYw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have already tried extracting the address of the "sys_call_table"
> from "System.Map"; however, I am still not able to replace the
> function-pointers with mine.

Correct.

> Trying to do gives me page-faults, apparently meaning that the
> syscall-table memory area is read-only.

Correct.

The kernel is specifically designed to stop such uses by rootkits and
trojans and other malware.

If you are trying to patch the system call table you are doing something
wrong. What are you actually trying to achieve ?
