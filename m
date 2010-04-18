Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab0DRUDw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 16:03:52 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:38811 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591Ab0DRUDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 16:03:49 -0400
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: 2.6.34rc4 NFS writeback regression (bisected): client often fails to delete things it just created
References: <87tyr9dfvv.fsf@spindle.srvr.nix>
	<1271618484.8049.1.camel@localhost.localdomain>
	<87vdboa7e0.fsf@spindle.srvr.nix>
	<1271620750.8049.3.camel@localhost.localdomain>
From: Nix <nix@esperi.org.uk>
Emacs: a learning curve that you can use as a plumb line.
Date: Sun, 18 Apr 2010 21:03:43 +0100
In-Reply-To: <1271620750.8049.3.camel@localhost.localdomain> (Trond Myklebust's message of "Sun, 18 Apr 2010 15:59:10 -0400")
Message-ID: <87mxx0a5pc.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-wuwien-Metrics: spindle 1290; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 Apr 2010, Trond Myklebust said:

> On Sun, 2010-04-18 at 20:27 +0100, Nix wrote: 
>> On 18 Apr 2010, Trond Myklebust verbalised:
>> tip-of-tree includes that commit, and it's still happening for me there.
>> (Just verified again.)
>
> Does a 'sync' clear out the sillyrenamed files?

Yes.
