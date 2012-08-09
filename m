Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab2HIOJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:09:14 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39017 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab2HIOJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:09:13 -0400
Date: Thu, 9 Aug 2012 15:13:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Marina Makienko <makienko@ispras.ru>
Cc: "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH 03/13] ide: Potential null pointer dereference in
 ide_queue_pc_tail()
Message-ID: <20120809151342.2941f851@pyramind.ukuu.org.uk>
In-Reply-To: <1344520529-19164-1-git-send-email-makienko@ispras.ru>
References: <1344520529-19164-1-git-send-email-makienko@ispras.ru>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 Aug 2012 17:55:20 +0400
Marina Makienko <makienko@ispras.ru> wrote:

> The function blk_get_request() can return NULL in some cases. There are
> checks on it if function is called with argumetns one of which is
> GFP_ATOMIC/GFP_NOIO/etc. If system couldn't find request
> blk_get_request() return NULL.

drivers/ide is obsolete and scheduled for removal. I'm not sure messing
with it is remotely useful at this point ?
