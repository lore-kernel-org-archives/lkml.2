Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab1BVOep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:34:45 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:60565 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab1BVOen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:34:43 -0500
Date: Tue, 22 Feb 2011 14:34:34 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mattia Dongili <malattia@linux.it>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the drivers-x86 tree
Message-ID: <20110222143434.GA9720@srcf.ucam.org>
References: <20110222162206.c3fb0636.sfr@canb.auug.org.au> <a8c6f32c-ccb5-4f65-b537-8bd1c11f7336@email.android.com> <20110222114601.GA936@kamineko.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222114601.GA936@kamineko.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 08:46:01PM +0900, Mattia Dongili wrote:

> how does linux-next work? should this patch be a separate commit or can
> it be folded into the offending one?

I'll fold it into the offending one and repush. Sorry about the 
breakage, Stephen - I don't have DEBUG_ALLOC enabled so didn't see the 
failure. Do you build with a defined configuration I can test against?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
