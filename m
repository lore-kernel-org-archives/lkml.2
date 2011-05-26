Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500Ab1EZTb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:31:29 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39501 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758438Ab1EZTb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:31:28 -0400
Date: Thu, 26 May 2011 20:31:11 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "D. Jansen" <d.g.jansen@googlemail.com>
Cc: Oliver Neukum <oneukum@suse.de>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tytso@mit.edu
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
Message-ID: <20110526193110.GA27504@srcf.ucam.org>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
 <201105231012.06928.oneukum@suse.de>
 <20110525000003.GJ32466@dastard>
 <201105250850.12179.oneukum@suse.de>
 <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 09:01:49AM +0200, D. Jansen wrote:

> Exactly. 0.5 Watts is a lot of energy on a modern system. And on some
> systems with proper link power management in sata and pcie it will be
> even higher (~1 Watt I think). Think not only of the work that will be
> lost if the system crashes (unlikely), but also of the work that could
> never be done because the battery was gone (a certainty).

I don't think link power management is relevant. The hysteresis there is 
sufficiently low that it's only going to make a difference during the 
point where you're actually throwing data across the link.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
