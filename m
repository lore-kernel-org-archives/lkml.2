Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab2J2XA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 19:00:58 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:6204 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753892Ab2J2XA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 19:00:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAG6Zu08YNPuJ/2dsb2JhbAANN4UtsgIBAQQjVQEQCxoCBRYLAgIJAwIBAgFFBg0BBwEBrxiSe4EmjgqBFAOoEA
X-IronPort-AV: E=Sophos;i="4.75,637,1330923600"; 
   d="scan'208";a="203108791"
Message-ID: <508F0AA6.6010702@teksavvy.com>
Date: Mon, 29 Oct 2012 19:00:54 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jacob Shin <jacob.shin@amd.com>, Ben Hutchings <ben@decadent.org.uk>,
        Yinghai Lu <yinghai@kernel.org>, Willy Tarreau <w@1wt.eu>,
        stable@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: Regression from 3.4.9 to 3.4.16 "stable" kernel
References: <508E002B.4090200@teksavvy.com> <20121029064643.GE574@1wt.eu> <508E913D.2080104@teksavvy.com> <1351521658.13356.7.camel@deadeye.wl.decadent.org.uk> <20121029144722.GA23217@jshin-Toonie> <20121029165823.GA6614@kroah.com>
In-Reply-To: <20121029165823.GA6614@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's something else very wrong when going from 3.4.9 to 3.4.16.
I've done it on two machines here, one the AMD-450 server (64-bit),
and the other my main notebook (Core2duo 32-bit-PAE).

Both systems feel much more sluggish than usual with 3.4.16 running.
Reverted them both back to earlier kernels (3.4.9, 3.4.4-PAE),
and the usual responsive feel has returned.

Vague, I know, but something bad happened in there somewhere.

Cheers
