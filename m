Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab2C0QHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 12:07:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37185 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab2C0QHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 12:07:33 -0400
Date: Tue, 27 Mar 2012 17:07:14 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Daniel Drake <dsd@laptop.org>,
        mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org, dilinger@queued.net, pgf@laptop.org
Subject: Re: [PATCH v4] x86, olpc: add debugfs interface for EC commands
Message-ID: <20120327160714.GA8398@srcf.ucam.org>
References: <20120326180710.8DF9C9D401E@zog.reactivated.net>
 <20120326142908.c5248aec.akpm@linux-foundation.org>
 <4F70E042.4020703@zytor.com>
 <20120326145146.23fde0db.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120326145146.23fde0db.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 02:51:46PM -0700, Andrew Morton wrote:

> Well, if a person had any contribution at all, we should seek their
> Signed-off-by:.  Otherwise they could say "hey, you admitted using my
> code but I did not authorise its use", or any other range of bad IANAL
> things?

The Certificate of Origin says:

        (b) The contribution is based upon previous work that, to the best
            of my knowledge, is covered under an appropriate open source
            license and I have the right under that license to submit that
            work with modifications, whether created in whole or in part
            by me, under the same open source license (unless I am
            permitted to submit under a different license), as indicated
            in the file; or

If a previous author has given a Signed-off-by then they've clearly 
indicated that their code is under an appropriate license and may be 
submitted to the kernel. If someone else then takes that code, modifies 
it and submits it then there's no obvious reason why we still need the 
original Signed-off-by. Giving credit to the original author is 
obviously appropriate, but I don't see why we need any more than that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
