Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab0DTWTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 18:19:48 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:33586 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab0DTWTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 18:19:47 -0400
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: 2.6.34rc4 NFS writeback regression (bisected): client often fails to delete things it just created
References: <87tyr9dfvv.fsf@spindle.srvr.nix>
	<1271618484.8049.1.camel@localhost.localdomain>
	<87vdboa7e0.fsf@spindle.srvr.nix>
	<1271620750.8049.3.camel@localhost.localdomain>
	<87mxx0a5pc.fsf@spindle.srvr.nix>
	<1271621624.8049.6.camel@localhost.localdomain>
	<87iq7oa2o8.fsf@spindle.srvr.nix>
	<1271682635.13653.40.camel@localhost.localdomain>
	<87aasz9ssu.fsf@spindle.srvr.nix>
	<1271767064.25129.84.camel@localhost.localdomain>
From: Nix <nix@esperi.org.uk>
Emacs: because you deserve a brk today.
Date: Tue, 20 Apr 2010 23:19:35 +0100
In-Reply-To: <1271767064.25129.84.camel@localhost.localdomain> (Trond Myklebust's message of "Tue, 20 Apr 2010 08:37:44 -0400")
Message-ID: <8739yphimg.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-Misty-Metrics: spindle 1170; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 Apr 2010, Trond Myklebust spake thusly:
> I therefore think we need something like the following patch.

OK. It'll be 24 hours before I can test this, I'm afraid (real life
intervenes).
