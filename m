Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264Ab2LHXE2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 18:04:28 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57715 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab2LHXE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 18:04:27 -0500
Date: Sat, 8 Dec 2012 23:09:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Cong Ding <dinggnu@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        greg@kroah.com
Subject: Re: [PATCH 1/2] tty: remove trailing spaces in tty/hvc
Message-ID: <20121208230945.3b8b27dd@pyramind.ukuu.org.uk>
In-Reply-To: <1354930884-20913-1-git-send-email-dinggnu@gmail.com>
References: <1354930884-20913-1-git-send-email-dinggnu@gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  8 Dec 2012 01:41:23 +0000
Cong Ding <dinggnu@gmail.com> wrote:

> remove trailing blank spaces in tty/hvc by shell command:
> sed 's/\s\+$//g' -i
> 
> I have manually reviewed that everything is correct.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>


Both acked-by: Alan Cox <alan@linux.intel.com>

Thanks
Alan
