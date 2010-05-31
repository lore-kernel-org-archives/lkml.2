Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab0EaROx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 13:14:53 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:45036 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703Ab0EaROv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 13:14:51 -0400
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-kernel@vger.kernel.org,
       Linux NFS Mailing List <nfs@lists.sourceforge.net>
Subject: Re: 2.6.34 nfs fsync() deadlock
References: <87r5ksjfql.fsf@spindle.srvr.nix>
	<1275320467.5038.9.camel@heimdal.trondhjem.org>
From: Nix <nix@esperi.org.uk>
Emacs: a Lisp interpreter masquerading as ... a Lisp interpreter!
Date: Mon, 31 May 2010 18:14:37 +0100
In-Reply-To: <1275320467.5038.9.camel@heimdal.trondhjem.org> (Trond Myklebust's message of "Mon, 31 May 2010 11:41:07 -0400")
Message-ID: <87ljb0j8n6.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-DCC-URT-Metrics: spindle 1060; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 May 2010, Trond Myklebust said:

> Can you see if the following 2 attached patches (already sent to
> stable@kernel.org) suffice to fix the hang?

I'm almost getting blasé about ultrafast solutions to NFS bugs by
now. I submit a problem report and it turns out it's already been
fixed or will be in fifteen minutes. :)

I have to wait for a RAID resync first *sigh* but after that I'll try
the patches out. I'll know in four hours or so... (the problem is
relatively rare: it takes ten or so postgresql 'make check' runs to
trigger it.)
