Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab2FMP5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:57:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46717 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab2FMP5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:57:37 -0400
Date: Wed, 13 Jun 2012 17:57:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Boszormenyi Zoltan <zboszor@pr.hu>
Cc: Johannes Stezenbach <js@sig21.net>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: AMD FX CPU bug, not fixed by latest microcode?
Message-ID: <20120613155733.GA17726@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Boszormenyi Zoltan <zboszor@pr.hu>,
	Johannes Stezenbach <js@sig21.net>, linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>
References: <4FD4F45D.5050103@pr.hu>
 <20120611084318.GA1685@liondog.tnic>
 <20120611094905.GA10349@liondog.tnic>
 <20120611110557.GA4599@sig21.net>
 <4FD8417B.8020702@pr.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FD8417B.8020702@pr.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 09:30:03AM +0200, Boszormenyi Zoltan wrote:
> This one locked up on my machine but memtest86+ 4.20 detected 12
> different addresses with faulty bits in the lower 16GB. Applying for
> warranty.

If you have multiple DIMMs, you can also take out the DIMM which
contains the 16GB and rerun memtest to confirm it really is the culprit.

-- 
Regards/Gruss,
    Boris.
