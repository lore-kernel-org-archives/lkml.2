Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030907Ab2LGVaD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 16:30:03 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57008 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab2LGVaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 16:30:00 -0500
Date: Fri, 7 Dec 2012 21:35:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Shilovsky <piastry@etersoft.ru>
Cc: Christoph Hellwig <hch@infradead.org>, <linux-cifs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <wine-devel@winehq.org>, <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 0/3] Add O_DENY* flags to fcntl and cifs
Message-ID: <20121207213520.05dd5a3b@pyramind.ukuu.org.uk>
In-Reply-To: <495d17310e0a687d446afc86def0f058@office.etersoft.ru>
References: <1354818391-7968-1-git-send-email-piastry@etersoft.ru>
	<20121207161602.GA17710@infradead.org>
	<495d17310e0a687d446afc86def0f058@office.etersoft.ru>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem is the possibility of denial-of-service attacks here. We 
> can try to prevent them by:
> 1) specifying an extra security bit on the file that indicates that 
> share flags are accepted (like we have for mandatory locks now) and 
> setting it for neccessary files only, or
> 2) adding a special mount option (but it it probably makes sense if we 
> decided to add this support for CIFS and NFS only).

3) making it a property that the process opts into - the same fs can have
Linux and wine users at once.

But for such a big set of changes and with the kind of potential fallout
you need to demonstrate a good practical use case IMHO, not just a "neat
idea I had".

Alan
