Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab1AJQgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:36:16 -0500
Received: from thunk.org ([69.25.196.29]:58657 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883Ab1AJQgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:36:14 -0500
Date: Mon, 10 Jan 2011 11:35:56 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, sandeen@redhat.com
Subject: Re: [PATCH] ext4: fix possible overflow in ext4_trim_fs()
Message-ID: <20110110163556.GB3128@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org,
	sandeen@redhat.com
References: <1290694277-29462-1-git-send-email-lczerner@redhat.com>
 <20101220123521.GH23626@thunk.org>
 <alpine.LFD.2.00.1101101221570.3095@dhcp-lab-213.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101101221570.3095@dhcp-lab-213.englab.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 12:25:05PM +0100, Lukas Czerner wrote:
> 
> Actually the patch is not enough, there is still a possibility for
> overflow to happen. Jan Kara notice the same bug in ext3 batched discard
> implementation. I am sorry for this, I'll sen updated patch ASAP.
> 

This isn't a new patch, and not a replacement for the previous one,
correct?

						- Ted
