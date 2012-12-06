Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947094Ab2LFTog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:44:36 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55415 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947077Ab2LFTod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:44:33 -0500
Date: Thu, 6 Dec 2012 19:49:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Shilovsky <piastry@etersoft.ru>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, wine-devel@winehq.org,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Add O_DENY* flags to fcntl and cifs
Message-ID: <20121206194949.7ab20d56@pyramind.ukuu.org.uk>
In-Reply-To: <1354818391-7968-1-git-send-email-piastry@etersoft.ru>
References: <1354818391-7968-1-git-send-email-piastry@etersoft.ru>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Dec 2012 22:26:28 +0400
Pavel Shilovsky <piastry@etersoft.ru> wrote:

> Network filesystems CIFS, SMB2.0, SMB3.0 and NFSv4 have such flags - this change can benefit cifs and nfs modules. While this change is ok for network filesystems, itsn't not targeted for local filesystems due security problems (e.g. when a user process can deny root to delete a file).

If I have my root fs on NFS then the same applies does it not.

Your patches fail to describe the security semantics and what file rights
I must have to apply each option. How do I track down a lock user, what
tools are provided ? How do the new options interact with the security
layer?

I don't have a problem with the idea, but it needs a lot more clear
description of how it works so the model can be checked and if need be
things tweaked (eg needing write to denywrite etc)

Alan
