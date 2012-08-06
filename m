Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab2HFMwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:52:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38943 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab2HFMwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:52:34 -0400
Date: Mon, 6 Aug 2012 13:52:16 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: cJ-ko@zougloub.eu, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Matt Fleming <matt.fleming@linux.intel.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Regression] "x86-64/efi: Use EFI to deal with platform wall
 clock" prevents my machine from booting
Message-ID: <20120806125216.GA11863@srcf.ucam.org>
References: <20120805172903.5f8bb24c@zougloub.eu>
 <501EF3A2.20200@zytor.com>
 <501F83F20200007800092C1C@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501F83F20200007800092C1C@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 07:44:34AM +0100, Jan Beulich wrote:

> In any case, without having seen _how_ things break I don't
> think a decision should be taken if/how to address this
> (apparent) regression.

Machines that previously worked no longer work. That's a pretty strong 
argument in favour of reverting until we can identify a workaround.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
