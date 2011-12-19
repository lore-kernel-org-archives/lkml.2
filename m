Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab1LSQKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 11:10:12 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51406 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1LSQKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 11:10:09 -0500
Date: Mon, 19 Dec 2011 16:09:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        paulus <paulus@samba.org>
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
Message-ID: <20111219160949.61461ce7@pyramind.ukuu.org.uk>
In-Reply-To: <1324309901.24621.14.camel@twins>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com>
	<1324309901.24621.14.camel@twins>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011 16:51:41 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2011-12-19 at 14:03 +0530, Nikunj A. Dadhania wrote:
> > The following patches implements gang scheduling. These patches
> >     are *highly* experimental in nature and are not proposed for
> >     inclusion at this time.
> 
> Nor will they ever be, I've always strongly opposed the whole concept
> and I'm not about to change my mind. Gang scheduling is a scalability
> nightmare. 

For most situations: I think the question is whether you can write a
clean gang scheduling option which has no impact on "normal" users. 

Yes gang scheduling is insane but for some insane workloads its the right
thing to do.

Alan
