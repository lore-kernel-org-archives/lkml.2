Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab2JJOFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:05:36 -0400
Received: from stringer.orebokech.com ([88.190.240.207]:45188 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab2JJOFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:05:33 -0400
From: Romain Francoise <romain@orebokech.com>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, hpa@zytor.com
Subject: Re: Linux 2.6.32.60
Organization: orebokech dot com
References: <20121009094453.GA4289@1wt.eu>
Date: Wed, 10 Oct 2012 16:05:32 +0200
In-Reply-To: <20121009094453.GA4289@1wt.eu> (Willy Tarreau's message of "Tue,
	9 Oct 2012 11:44:53 +0200")
Message-ID: <87y5jeqv6b.fsf@silenus.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Willy,

Willy Tarreau <w@1wt.eu> writes:

> I've just released Linux 2.6.32.60.

> This release contains, among others, a number of fixes for random and NTP,
> including for the NTP leap second bug. Users should upgrade.

I'm somewhat surprised to see that it also includes a new feature, namely
support for Intel's new RDRAND instruction to get random bits ("Bull
Mountain"):

67c1930 ("x86, random: Verify RDRAND functionality and allow it to be disabled")
5e6321d ("x86, random: Architectural inlines to get random integers with RDRAND")

This was apparently backported from 3.2 via Paul's 2.6.34 tree. Did you
test this release on a CPU with RDRAND? The commits are small, but they
don't really qualify as bugfix-only...

In v3.0-stable the various changes to mix more randomness in the entropy
pool were backported without this feature.

Thanks,
-r

