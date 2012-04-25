Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab2DYRmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 13:42:20 -0400
Received: from cs-smtp-2.Stanford.EDU ([171.64.64.26]:45169 "EHLO
	cs-smtp-2.Stanford.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab2DYRmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 13:42:19 -0400
X-Greylist: delayed 1286 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Apr 2012 13:42:19 EDT
From: Ben Pfaff <blp@cs.stanford.edu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add kabs()
References: <20120423131106.GA27574@p183.telecom.by>
Reply-To: blp@cs.stanford.edu
Date: Wed, 25 Apr 2012 10:20:48 -0700
In-Reply-To: <20120423131106.GA27574@p183.telecom.by> (Alexey Dobriyan's
	message of "Mon, 23 Apr 2012 16:11:06 +0300")
Message-ID: <87k413pw27.fsf@blp.benpfaff.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Spam-Score: -1.8
X-Scan-Signature: 58355bea2820b4cf9b9c8322cdf0b49d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:

> kabs() has the following nice properties which should have been there
> from day 1.
>
> kabs() return unsigned value.
> kabs() works for all integer types and return correct result.
> sizeof(kabs(x)) == sizeof(x)

It would be nice to document these properties in a source code
comment, as well as in the commit message.
