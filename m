Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab0INSU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 14:20:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38456 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab0INSU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 14:20:28 -0400
Message-ID: <4C8FBCCA.6060001@zytor.com>
Date: Tue, 14 Sep 2010 11:19:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Hellwig <hch@lst.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] x86: should 32 bit processes be PER_LINUX32
References: <1284480057-18120-1-git-send-email-apw@canonical.com>
In-Reply-To: <1284480057-18120-1-git-send-email-apw@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2010 09:00 AM, Andy Whitcroft wrote:
> While testing an x86 64 bit kernel on 32 bit userspace I noticed that I
> was unexpectedly seeing x86_64 as the architecture as reported in uname.
> The kernel seems to have code to detect 32 bit userspace and slam this
> to i686, triggered off the personality PER_LINUX32.  However 32 bit
> processes do not seem to get this flag.  I think this is an oversight.
> The following patch attempts to fix this up.

No, it's not an oversight.  It's possible to hide it behind PER_LINUX32,
but that's a bigger hammer that not all users want.

	-hpa
