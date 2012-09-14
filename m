Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915Ab2INSvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:51:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38463 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756939Ab2INSvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:51:05 -0400
Date: Fri, 14 Sep 2012 20:51:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets
Message-ID: <20120914185107.GB30757@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
 <20120914184032.GA30753@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120914184032.GA30753@x1.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 08:40:32PM +0200, Borislav Petkov wrote:
> I'll try a coarse bisection of the -rcs first, to see where the
> regression appeared.

Ok, 3.6-rc1 already shows the regression so I have to do the normal
bisection now to see which patch caused it.

Stay tuned.

-- 
Regards/Gruss,
Boris.
