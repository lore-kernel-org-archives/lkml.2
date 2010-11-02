Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab0KBEYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 00:24:35 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:53826 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab0KBEYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 00:24:31 -0400
Date: Mon, 1 Nov 2010 21:24:30 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, srajiv@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: suspend fails on x200 (was Re: [PATCH] tpm: Autodetect itpm
	devices)
Message-ID: <20101102042430.GZ5988@hexapodia.org>
References: <1287697360-31273-1-git-send-email-mjg@redhat.com> <20101102013106.GX5988@hexapodia.org> <20101102023628.GB19250@hexapodia.org> <201011020447.53273.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011020447.53273.rjw@sisk.pl>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 04:47:53AM +0100, Rafael J. Wysocki wrote:
> > > So, definitely something exciting going on... and not a simple
> > > suspend regression, and definitely not caused by this patch, my
> > > apologies.  Subject line updated accordingly.
> > > 
> > > I'll try applying "Autodetect itpm devices" and report back.
> > 
> > With your patch applied on top of -rc1, suspend + resume seems to work
> > fine, and I don't have any error messages from tpm in dmesg.
> > 
> > Thanks, problem solved.  (Still no idea what caused that one
> > hang-with-blinking-moon, but it doesn't appear to be connected.)
> 
> Please give us a pointer to the patch, there are other users
> experiencing this issue.

My iTPM-causes-suspend-to-fail is fixed by the head message in this
thread, <1287697360-31273-1-git-send-email-mjg@redhat.com>,
http://lkml.org/lkml/2010/10/21/456

-andy
