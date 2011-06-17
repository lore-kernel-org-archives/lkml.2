Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817Ab1FQJDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 05:03:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58293 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758001Ab1FQJDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 05:03:07 -0400
Date: Fri, 17 Jun 2011 11:03:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: chrish@techspecs.com
Cc: linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: PROBLEM: AMD Zacate E350 shows only 2.6GB memory when 8GB
 installed
Message-ID: <20110617090303.GB939@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, chrish@techspecs.com,
	linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Borislav Petkov <borislav.petkov@amd.com>
References: <53e44025a84a55558f4fb1dea8642ab6.squirrel@mail.techspecs.com>
 <4DFAF9A3.6090802@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DFAF9A3.6090802@ladisch.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 08:52:19AM +0200, Clemens Ladisch wrote:
> chrish@techspecs.com wrote:
> >    I tried this on Fedora 14 and OpenSuse 11.4 and both exhibit the same
> > behavior. 8GB is installed but only 2698476 shows available for use
> > using "top" or "free".
> 
> /proc/iomem?
> dmesg?

Also, do you have the latest BIOS? If not, can you update it? Also, can
you try the latest upstream kernel to verify the problem still exists?

Thanks.

-- 
Regards/Gruss,
    Boris.
