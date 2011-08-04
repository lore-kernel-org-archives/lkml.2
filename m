Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab1HDS40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 14:56:26 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36412 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab1HDS4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 14:56:21 -0400
Date: Thu, 4 Aug 2011 19:56:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "MRU.Ilya" <utdilya@mail.ru>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BUG: pty.c  in linux 2.6.31-rc5+
Message-ID: <20110804195607.2f9bc468@pyx>
In-Reply-To: <4E3A3F87.3050204@mail.ru>
References: <4E3A3F87.3050204@mail.ru>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Aug 2011 10:43:19 +0400
"MRU.Ilya" <utdilya@mail.ru> wrote:

> Synchronic's line disciplines(ppp_synctty, hdlc) can't work with pseudo 
> terminals.

Correct - tty devices do not support framing. This is intentional.

