Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab2AZMId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 07:08:33 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52988 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab2AZMIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 07:08:32 -0500
Date: Thu, 26 Jan 2012 12:09:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dima Zavin <dima@android.com>
Cc: Kashyap Gada <gada.kashyap@gmail.com>, gregkh@suse.de, rebecca@android.com,
        rschultz@google.com, jgennis@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Staging: android: Add KERN_ facility level in
 printk () in pmem.c
Message-ID: <20120126120947.220bbc3a@pyramind.ukuu.org.uk>
In-Reply-To: <CAPz4a6AUAMxcMkVkgc9UJ1tok36jNE5hZzJc_9n5EJqRQCcz2w@mail.gmail.com>
References: <1327116249-18274-1-git-send-email-gada.kashyap@gmail.com>
	<CAPz4a6AUAMxcMkVkgc9UJ1tok36jNE5hZzJc_9n5EJqRQCcz2w@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012 09:22:27 -0800
Dima Zavin <dima@android.com> wrote:

> We really should just get rid of pmem.c altogether. We will remove it
> from our android common tree too. We don't actually use it anymore in
> any of our products. There are some legacy users of it, like Qualcomm,
> but I'm sure they have a bunch of patches on top of it and thus are
> maintaining it separately anyway.

Probably wise if nobody ever fixed the security holes in it.

Alan
