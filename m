Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1FCV5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 17:57:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54350 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752497Ab1FCV5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 17:57:43 -0400
Date: Fri, 3 Jun 2011 22:58:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Timur Tabi <timur@freescale.com>, linux-kernel@vger.kernel.org,
        scottwood@freescale.com, akpm@linux-foundation.org
Subject: Re: [PATCH] lib: introduce strdup_from_user
Message-ID: <20110603225858.53e796ca@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTikFjF0WF---8A9_CBybf+bUji2smw@mail.gmail.com>
References: <1307119552-15573-1-git-send-email-timur@freescale.com>
	<BANLkTikFjF0WF---8A9_CBybf+bUji2smw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jun 2011 20:45:10 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> NAK
> It accesses userspace data twice.

Big deal, processors have caches.

Just needs the zero termination to be reliable.

Alan
