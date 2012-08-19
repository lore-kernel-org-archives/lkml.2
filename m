Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab2HSMUF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 08:20:05 -0400
Received: from oker.escape.de ([194.120.234.254]:54542 "EHLO oker.escape.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698Ab2HSMUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 08:20:00 -0400
X-Greylist: delayed 873 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Aug 2012 08:20:00 EDT
Date: Sun, 19 Aug 2012 14:02:54 +0200
From: Jochen Striepe <jochen@tolot.escape.de>
To: Dan Luedtke <mail@danrl.de>
Cc: Marco Stornelli <marco.stornelli@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, lanyfs@librelist.com
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
Message-ID: <20120819120254.GA2369@pompeji.miese-zwerge.org>
References: <1345333117-2826-1-git-send-email-mail@danrl.de>
 <CAFLxGvwwAX=85hmgxg6qGTpp4YCppuj2mpw7GkB1eV8qhta2bg@mail.gmail.com>
 <1345371135.4441.2.camel@tunafish>
 <5030BC7E.3030000@gmail.com>
 <1345383264.4441.56.camel@tunafish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345383264.4441.56.camel@tunafish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello,

On Sun, Aug 19, 2012 at 03:34:24PM +0200, Dan Luedtke wrote:
> tried using ext3, but the ownership information from my workstation
> (were the file was copied from) did not match the ones the RaspberryPI
> had, since I usually do not synchronize user profiles between
> workstations and embedded devices. There are workarounds, one might say,

You wrote a new fs just because you didn't bother to use the existing
ones as intended?

Puzzled,
Jochen.
