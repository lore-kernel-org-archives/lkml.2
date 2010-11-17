Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab0KQJuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 04:50:07 -0500
Received: from lo.gmane.org ([80.91.229.12]:56922 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab0KQJuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 04:50:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Philipp Marek <philipp@marek.priv.at>
Subject: Re: [ANNOUNCE] New utility: 'trace'
Date: Wed, 17 Nov 2010 09:49:07 +0000 (UTC)
Message-ID: <loom.20101117T104011-153@post.gmane.org>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 86.59.100.100 (Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.15) Gecko/20101028 Iceweasel/3.5.15 (like Firefox/3.5.15))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas!

Thomas Gleixner <tglx <at> linutronix.de> writes:
> We are pleased to announce a new tracing tool called 'trace'.
...
>   read(3:</usr/bin/firefox>, buf: 0x7fffcc4caf40, count: 0x80)

Is there a way to get (parts of) the data being read/written/sent/received?
Something like the -s flag for strace would be nice, but that already seems
taken for scheduler events.


Regards,

Phil


