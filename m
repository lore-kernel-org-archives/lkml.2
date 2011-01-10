Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab1AJREK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 12:04:10 -0500
Received: from thunk.org ([69.25.196.29]:39230 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359Ab1AJREF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 12:04:05 -0500
Date: Mon, 10 Jan 2011 12:04:01 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, sandeen@redhat.com
Subject: Re: [PATCH] ext4: fix possible overflow in ext4_trim_fs()
Message-ID: <20110110170401.GC3128@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org,
	sandeen@redhat.com
References: <1290694277-29462-1-git-send-email-lczerner@redhat.com>
 <20101220123521.GH23626@thunk.org>
 <alpine.LFD.2.00.1101101221570.3095@dhcp-lab-213.englab.brq.redhat.com>
 <20110110163556.GB3128@thunk.org>
 <alpine.LFD.2.00.1101101752290.3095@dhcp-lab-213.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101101752290.3095@dhcp-lab-213.englab.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 05:52:49PM +0100, Lukas Czerner wrote:
> 
> It is the replacement for the previous one.
> 

Ah, I see, I got it confused with another trim_fs patch.  I wish you
had sent this to me earlier, but ok, I'll fix it up.

    	      	    	     	     	  - Ted
