Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab2JDRU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:20:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35744 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756516Ab2JDRU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:20:56 -0400
Date: Thu, 4 Oct 2012 18:20:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>,
        Marcelo Tosatti <mtosatti@redhat.com>
Message-ID: <20121004172054.GB13292@decadent.org.uk>
References: <6a854f579a99b4fe2efaca1057e8ae22@local>
 <20121001225159.352867398@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001225159.352867398@1wt.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 041/180] KVM: x86: fix missing checks in syscall emulation
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 12:52:38AM +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: =?latin1?q?Stephan=20B=E4rwolf?= <stephan.baerwolf@tu-ilmenau.de>
> 
> commit bdb42f5afebe208eae90406959383856ae2caf2b upstream
[...]

This is also wrong; it's the upstream commit hash for the previous
fix!  The correct hash is c2226fc9e87ba3da060e47333657cd6616652b84.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
