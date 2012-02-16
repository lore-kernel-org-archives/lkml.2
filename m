Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab2BPO2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:28:47 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58452 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2BPO2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:28:46 -0500
Date: Thu, 16 Feb 2012 14:27:28 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com,
        stable@kernel.org
Subject: Re: [PATCH 2/2] efi: Validate UEFI boot variables
Message-ID: <20120216142728.64ed46e7@pyramind.ukuu.org.uk>
In-Reply-To: <1329400717-22670-2-git-send-email-mjg@redhat.com>
References: <1329400717-22670-1-git-send-email-mjg@redhat.com>
	<1329400717-22670-2-git-send-email-mjg@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012 08:58:37 -0500
Matthew Garrett <mjg@redhat.com> wrote:

> A common flaw in UEFI systems is a refusal to POST triggered by a malformed
> boot variable. Once in this state, machines may only be restored by
> reflashing their firmware with an external hardware device. While this is
> obviously a firmware bug, the serious nature of the outcome suggests that
> operating systems should filter their variable writes in order to prevent
> a malicious user from rendering the machine unusable.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Other than pr_err() as a nitpick comemnt this looks good to me

Acked-by: Alan Cox <alan@linux.intel.com>
