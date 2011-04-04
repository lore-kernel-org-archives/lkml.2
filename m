Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab1DDSQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 14:16:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39718 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754960Ab1DDSQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 14:16:55 -0400
Date: Mon, 4 Apr 2011 19:17:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: Reorder reboot method preferences
Message-ID: <20110404191724.268310b6@lxorguk.ukuu.org.uk>
In-Reply-To: <1301939705-2404-1-git-send-email-mjg@redhat.com>
References: <1301939705-2404-1-git-send-email-mjg@redhat.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  4 Apr 2011 13:55:05 -0400
Matthew Garrett <mjg@redhat.com> wrote:

> Windows reboots by hitting the ACPI reboot vector (if available), trying
> the keyboard controller, hitting the ACPI reboot vector again and then
> giving the keyboard controller one last go. This is important for modern
> hardware, which often lacks a keyboard controller and may even wedge if the
> legacy io ports are hit. Rework our reboot process a little to default to
> matching this behaviour, although we'll fall through to attempting a triple
> fault if nothing else works.

Acked-by: Alan Cox <alan@linux.intel.com>

and will also save special casing Oaktrail boards
