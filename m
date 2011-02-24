Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab1BXRFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:05:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47575 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601Ab1BXRE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:04:59 -0500
Date: Thu, 24 Feb 2011 18:04:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Borislav Petkov <bp@amd64.org>
Cc: David Sterba <dsterba@suse.cz>, "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] i7core_edac: fix misuse of logical operation in
 place of bitop
Message-ID: <20110224170455.GC17619@ds.suse.cz>
Reply-To: dsterba@suse.cz
References: <20110221144146.GE5766@ds.suse.cz>
 <20110224140541.GB11239@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224140541.GB11239@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 03:05:41PM +0100, Borislav Petkov wrote:
> Yeah, this looks wrong. Is this tested?

Compile tested, I don't have the hw at hand.

> Is it something you hit when running the driver or you've caught it
> with some tool/by code staring?

It was found by clang compiler.

> If it is a real problem for you, I could make an exception and send it
> to Linus next week if Mauro doesn't do it before that.

Not a problem for me, I just don't want let the patch fall on the floor.

Thanks,
dave
