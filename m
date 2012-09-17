Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab2IQNyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:54:32 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33200 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab2IQNyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:54:31 -0400
Date: Mon, 17 Sep 2012 14:59:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: fix unterminated string
Message-ID: <20120917145923.132334c9@pyramind.ukuu.org.uk>
In-Reply-To: <20120917104901.29914.81645.stgit@localhost.localdomain>
References: <20120917104901.29914.81645.stgit@localhost.localdomain>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2012 11:49:30 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@linux.intel.com>
> 
> oom_score_adj_write doesn't terminate the string as it should. Also fix
> sched_autogroup_write and other copy/pastes of the bug.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Cc: Horses <stable@vger.kernel.org>

Ok ignore this one - its in fact safe having poked at it further - the
memset ensures the buffer is terminated. Ugly but the existing code works
fine 8)


