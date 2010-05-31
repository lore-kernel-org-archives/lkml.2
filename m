Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab0EaPDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 11:03:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57746 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab0EaPDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 11:03:07 -0400
Date: Mon, 31 May 2010 16:03:00 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [GIT PULL] x86 platform driver updates for 2.6.35
Message-ID: <20100531150300.GA19134@srcf.ucam.org>
References: <20100528182549.GA32694@srcf.ucam.org> <alpine.LFD.2.00.1005300914460.4639@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005300914460.4639@i5.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 30, 2010 at 09:15:32AM -0700, Linus Torvalds wrote:

> This doesn't seem to have the proper sign-off chains, so I'm not pulling 
> it. 

Sorry about that. I've fixed things up - are you ok with still pulling 
this? If not I can separate out the bugfixes and new drivers from the 
cleanups.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
