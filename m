Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab2KFJHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 04:07:33 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40862 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab2KFJH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 04:07:28 -0500
Date: Tue, 6 Nov 2012 09:12:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121106091217.4a5240f0@pyramind.ukuu.org.uk>
In-Reply-To: <20121106035352.GA24698@srcf.ucam.org>
References: <20121104135251.GA17894@srcf.ucam.org>
	<87d2zsmv8r.fsf@xmission.com>
	<509766DB.9090906@zytor.com>
	<87625kh5r2.fsf@xmission.com>
	<20121105123858.GB4374@srcf.ucam.org>
	<87sj8nc137.fsf@xmission.com>
	<20121105202557.GA16076@srcf.ucam.org>
	<87hap3zbw7.fsf@xmission.com>
	<20121106031219.GB24235@srcf.ucam.org>
	<87fw4nv1vj.fsf@xmission.com>
	<20121106035352.GA24698@srcf.ucam.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2012 03:53:52 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Mon, Nov 05, 2012 at 07:36:32PM -0800, Eric W. Biederman wrote:
> 
> > For automated installs you don't have to satisfy me.  Feel free to
> > deliver a lousy solution to your users.   Just don't use your arbitrary
> > design decisions to justify your kernel patches.
> 
> My kernel patches are justified by genuine user requirements.

So are lots of patches tht don't go in because they are too ugly or too
invasive or two special case for mainstream.

There are two discussions here

- is it worth Red Hat doing - that's up to Red Hat's business managers

- is it worth merging into the kernel - that's not

The capability bit is small and clean the rest of it is beginning to look
far too ugly for upstream right now. Not to say it might not end up small
and clean in the end.

Alan
