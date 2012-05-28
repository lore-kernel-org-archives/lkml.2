Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2E1PMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 11:12:39 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49293 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752215Ab2E1PMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 11:12:37 -0400
Message-ID: <1338217956.2202.27.camel@joe2Laptop>
Subject: Re: [PATCH V3] checkpatch: check for whitespace before semicolon at
 EOL
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Eric Nelson <eric.nelson@boundarydevices.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Date: Mon, 28 May 2012 08:12:36 -0700
In-Reply-To: <20120528144259.GA5878@dm>
References: <1338163246-6727-1-git-send-email-eric.nelson@boundarydevices.com>
	 <20120528144259.GA5878@dm>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-28 at 15:42 +0100, Andy Whitcroft wrote:
> On Sun, May 27, 2012 at 05:00:46PM -0700, Eric Nelson wrote:
> > +# check for whitespace before a non-naked semicolon
> > +		if ($line =~ /^\+.*\S\s+;/) {
> > +			CHK("SPACING",
> > +			    "space prohibited before semicolon\n" . $herecurr);
> > +		}
> > +
> 
> Would this not also falsly trigger on 'for (foo = 10; foo; foo--) {' ?

No, it checks for a non-space, then requires whitespace before the semi


