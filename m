Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab1AJTud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 14:50:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab1AJTuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:50:32 -0500
Date: Mon, 10 Jan 2011 20:50:27 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-lab-213.englab.brq.redhat.com
To: "Ted Ts'o" <tytso@mit.edu>
cc: Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org,
        sandeen@redhat.com
Subject: Re: [PATCH] ext4: fix possible overflow in ext4_trim_fs()
In-Reply-To: <20110110170401.GC3128@thunk.org>
Message-ID: <alpine.LFD.2.00.1101102049580.3095@dhcp-lab-213.englab.brq.redhat.com>
References: <1290694277-29462-1-git-send-email-lczerner@redhat.com> <20101220123521.GH23626@thunk.org> <alpine.LFD.2.00.1101101221570.3095@dhcp-lab-213.englab.brq.redhat.com> <20110110163556.GB3128@thunk.org> <alpine.LFD.2.00.1101101752290.3095@dhcp-lab-213.englab.brq.redhat.com>
 <20110110170401.GC3128@thunk.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011, Ted Ts'o wrote:

> On Mon, Jan 10, 2011 at 05:52:49PM +0100, Lukas Czerner wrote:
> > 
> > It is the replacement for the previous one.
> > 
> 
> Ah, I see, I got it confused with another trim_fs patch.  I wish you
> had sent this to me earlier, but ok, I'll fix it up.
> 
>     	      	    	     	     	  - Ted
> 

Yes, sorry about that and thanks.

-Lukas
