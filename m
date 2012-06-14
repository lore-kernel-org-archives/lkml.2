Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab2FNOBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:01:45 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57851 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab2FNOBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:01:44 -0400
Date: Thu, 14 Jun 2012 15:05:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kamil Dudka <kdudka@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2o: avoid returning pointer to a local array in
 chtostr()
Message-ID: <20120614150525.5c0ed7f0@pyramind.ukuu.org.uk>
In-Reply-To: <1339678302-23770-1-git-send-email-kdudka@redhat.com>
References: <1339678302-23770-1-git-send-email-kdudka@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012 14:51:42 +0200
Kamil Dudka <kdudka@redhat.com> wrote:

> The pointer returned from chtostr() points to an array which is no longer valid
> when being used in the calling function.  Although it may work, the behavior is
> undefined.  Detected by cppcheck.
> 
> Signed-off-by: Kamil Dudka <kdudka@redhat.com>

Acked-by: Alan Cox <alan@linux.intel.com>

