Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751Ab2KBXlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 19:41:16 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36990 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759998Ab2KBXlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 19:41:13 -0400
Date: Fri, 2 Nov 2012 23:46:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris Friesen <chris.friesen@genband.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121102234607.26cc2cbb@pyramind.ukuu.org.uk>
In-Reply-To: <509446FB.5000504@genband.com>
References: <CACLa4pu0yoB6CQX=3nuAT2vz4=oTNfM9fjMUvFXKJovYu+y4fw@mail.gmail.com>
	<1351803800.2391.96.camel@dabdike.int.hansenpartnership.com>
	<20121101210634.GA19723@srcf.ucam.org>
	<20121101213127.5967327f@pyramind.ukuu.org.uk>
	<20121101212843.GA20309@srcf.ucam.org>
	<20121101213751.377ebaa8@pyramind.ukuu.org.uk>
	<20121101213452.GA20564@srcf.ucam.org>
	<20121101215817.79e50ec2@pyramind.ukuu.org.uk>
	<20121101215752.GA21154@srcf.ucam.org>
	<87625ogzje.fsf@xmission.com>
	<20121102140057.GA4668@srcf.ucam.org>
	<87liejacix.fsf@xmission.com>
	<509446FB.5000504@genband.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Nov 2012 16:19:39 -0600
Chris Friesen <chris.friesen@genband.com> wrote:

> On 11/02/2012 04:03 PM, Eric W. Biederman wrote:
> > Matthew Garrett<mjg59@srcf.ucam.org>  writes:
> >
> >> On Fri, Nov 02, 2012 at 01:49:25AM -0700, Eric W. Biederman wrote:
> >>
> >>> When the goal is to secure Linux I don't see how any of this helps.
> >>> Windows 8 compromises are already available so if we turn most of these
> >>> arguments around I am certain clever attackers can go through windows to
> >>> run compromised kernel on a linux system, at least as easily as the
> >>> reverse.
> >>
> >> And if any of them are used to attack Linux, we'd expect those versions
> >> of Windows to be blacklisted.

This is the first laugh. So they revoke the key. For that to be useful
they must propogate that into all the boxes in warehouses and all the new
boxes. If they do that then all the existing store stock of Windows 8 DVD
and CD media needs replacing.

> > I don't want my system p0wned in the first place and I don't want to run
> > windows.  Why should I trust Microsoft's signing key?
> 
> In any case, you don't need to trust Microsoft's signing key...at least 
> on x86 hardware you can install your own.  But if you want consumer 
> hardware to be able to boot linux out-of-the-box without messing with 
> BIOS settings then we need a bootloader that has been signed by Microsoft.

Or a machine that has other keys in it, isn't sold locked down or doesn't
have lunatic boot firmware.

Alan
