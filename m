Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719Ab1ELT0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 15:26:44 -0400
Received: from bsmtp3.bon.at ([213.33.87.17]:27289 "EHLO lbmfmo03.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757615Ab1ELT0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 15:26:42 -0400
X-Greylist: delayed 1886 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 May 2011 15:26:41 EDT
Message-ID: <4DCC2CFD.4010807@kdbg.org>
Date: Thu, 12 May 2011 20:54:53 +0200
From: Johannes Sixt <j6t@kdbg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Lutomirski <luto@mit.edu>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, git@vger.kernel.org
Subject: Re: AAARGH bisection is hard (Re: [2.6.39 regression] X locks up
 hard right after logging in)
References: <BANLkTi=kb_m-CfrpnD8qQTVYLGaDdgy_tg@mail.gmail.com> <BANLkTi=YDZa+BRaG90vJsjrT9VxgySrDRQ@mail.gmail.com>
In-Reply-To: <BANLkTi=YDZa+BRaG90vJsjrT9VxgySrDRQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.05.2011 19:37, schrieb Linus Torvalds:
> If you think it's networking, for example, and you've bisected into
> there but aren't sure, do "gitk --bisect", find the point where I
> merge, and pick that (and my parent), and "git bisect reset" those
> points.

Except that you should git reset --hard; git bisect reset gets you out
of bisect-mode, no?

-- Hannes
