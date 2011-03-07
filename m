Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab1CGQBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 11:01:09 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50783 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753340Ab1CGQBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 11:01:06 -0500
Date: Mon, 7 Mar 2011 16:00:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] Define ENONAMESERVICE and ENAMEUNKNOWN to indicate
 name service errors
Message-ID: <20110307160042.2ddc8e65@lxorguk.ukuu.org.uk>
In-Reply-To: <20110307150218.28218.84916.stgit@warthog.procyon.org.uk>
References: <20110307150208.28218.89348.stgit@warthog.procyon.org.uk>
	<20110307150218.28218.84916.stgit@warthog.procyon.org.uk>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Define ENONAMESERVICE to indicate "Network name service unavailable".  This can
> be used to indicate, for example, that an attempt was made by dns_query() to
> make a query, but the name server (e.g. a DNS server) it is supposed to contact
> didn't answer or that it couldn't determine the location of a suitable server.

Are these in glibc and are there glibc patches submitted and accepted for
this ?

(I only ask because I know its previously taken years for glibc to catch
up with stuff)
