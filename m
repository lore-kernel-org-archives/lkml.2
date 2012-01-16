Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab2APVai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 16:30:38 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:54079 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab2APVah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 16:30:37 -0500
Date: Mon, 16 Jan 2012 21:30:24 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michael D Labriola <mlabriol@gdeb.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Kushal Koolwal <kushalkoolwal@gmail.com>,
        support@versalogic.com, michael.d.labriola@gmail.com
Subject: Re: Reboot hangs on VersaLogic Ocelot
Message-ID: <20120116213024.GC6313@srcf.ucam.org>
References: <OFE7865F25.43E4BFD2-ON85257984.0057CD12-85257984.0058D31D@gdeb.com>
 <20120116075348.GF15641@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116075348.GF15641@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 08:53:48AM +0100, Ingo Molnar wrote:
> Please send a patch that removes the quirk (not named a revert - 
> as technically the old quirk did solve problems), with the 
> changelog containing your (excellent) bug analysis and the test 
> coverage above, plus a signoff?
> 
> Matthew, do you concur? Looks like your reordering changes 
> actively improved the default behavior and we can start removing 
> quirks.

Well, that was certainly the aim. Dropping the quirk here should be 
correct.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
