Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab1JCCoM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 22:44:12 -0400
Received: from fn.samba.org ([216.83.154.106]:51533 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab1JCCoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 22:44:05 -0400
Date: Sun, 2 Oct 2011 19:44:02 -0700
From: Jeremy Allison <jra@samba.org>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Jim McDonough <jmcd@samba.org>,
        Lars =?iso-8859-1?Q?M=FCller?= <lmuelle@suse.de>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        LKML <linux-kernel@vger.kernel.org>,
        PWF Linux <pwf-linux@ucs.cam.ac.uk>, Steve French <sfrench@samba.org>,
        Jeremy Allison <jra@samba.org>
Subject: Re: CIFS kernel module bug
Message-ID: <20111003024402.GB1644@jeremy-desktop>
Reply-To: Jeremy Allison <jra@samba.org>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk>
 <20110930140409.51c1a94c@tlielax.poochiereds.net>
 <E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk>
 <20110930234711.GD14147@samba2>
 <alpine.LSU.2.00.1110010122210.15683@hermes-2.csi.cam.ac.uk>
 <6704F264-5437-4948-8C1B-FE3F5CE59C24@cam.ac.uk>
 <20111001150730.GJ5170@giles.fritz.box>
 <6A5AB13C-F313-4BF2-A402-F41AB53493F0@cam.ac.uk>
 <CAFneQcc8D7ho-Yfr2X0DxaLLX11iMU=wSgCw9daKoViZCMk6dA@mail.gmail.com>
 <65C75335-2A74-4B00-989A-212BAC06A646@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <65C75335-2A74-4B00-989A-212BAC06A646@cam.ac.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 09:16:33PM +0100, Anton Altaparmakov wrote:
> 
> That is correct but apparently Salford Software (who handle our Netware & OES site license here in the UK including providing support) have told the guys running the file server that the samba server on OES is not scalable, has loads of bugs, and they must stay away from it at all costs and that they would not provide any support if our filestore runs that instead of the Novell CIFSd.
> 
> You can understand why the filestore is thus running the Novell CIFSd rather than Samba…
> 
> PS. Whether this is FUD or not I cannot comment on.  I am just passing on what I was told!

Wow. And Samba being (partly) a UK-written project too (at least
 from me :-).

I think the Samba Team members from Novell who work full time
on said Samba server in OES might have some follow-ups here,
so I think I'll let them do that.

FYI. Just for fun, try running smbtorture4 against the CIFSd
thing you're running now. I'll be (probably) grimly amused by
the results. A warning - don't do that on a production system :-).

Jeremy.
