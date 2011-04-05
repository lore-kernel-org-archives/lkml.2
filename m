Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab1DERW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 13:22:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56584 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754171Ab1DERW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 13:22:56 -0400
Date: Tue, 5 Apr 2011 18:23:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>, mikew@google.com,
        Greg KH <greg@kroah.com>
Subject: Re: /sys/firmware/dmi name change?
Message-ID: <20110405182324.6dbbba08@lxorguk.ukuu.org.uk>
In-Reply-To: <4D9B4E3A.4090601@redhat.com>
References: <4D9B4E3A.4090601@redhat.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Apr 2011 13:15:38 -0400
Prarit Bhargava <prarit@redhat.com> wrote:

> commit 948af1f0bbc8526448e8cbe3f8d3bf211bdf5181 (and follow on commits)
> introduced a new firmware directory called /sys/firmware/dmi which
> provides broken out SMBIOS entries for userspace.
> 
> In a previous discussion I've mentioned that it would be a good idea for
> us to move away from using 'dmi' towards using 'smbios' and centralizing
> the SMBIOS code that is scattered throughout the kernel.  One of my
> changes was to export the SMBIOS information in a similar way that Mike
> did in drivers/firmware/dmi-sysfs.c.
> 
> Since this API is new for 2.6.39, can we change the name of the
> directory to /sys/firmware/smbios?  Otherwise in 2.6.40, when further
> changes are introduced to use SMBIOS in the kernel we will have to
> change something that has been stable for one release.
> 
> Mike?  Greg?  Alan?  What do you think?  IIUC, the interface isn't yet
> "stable" so it should be changed now, correct?

Seems sensible to me

Alan
