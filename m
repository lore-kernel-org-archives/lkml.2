Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab2BUMPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 07:15:10 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:47542 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab2BUMPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 07:15:09 -0500
X-Greylist: delayed 2417 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Feb 2012 07:15:08 EST
Date: Tue, 21 Feb 2012 12:34:48 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Yang Honggang <eagle.rtlinux@gmail.com>
Cc: linux-kernel@vger.kernel.org, hjk@hansjkoch.de
Subject: Re: your mail
Message-ID: <20120221113448.GA2646@local>
References: <4F43BAA6.2070900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F43BAA6.2070900@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 10:39:18AM -0500, Yang Honggang wrote:
> hi, everyone

Please give your mail a proper subject line before posting.
If you talk about UIO, it should start with uio:
Otherwise, people won't read it and just send it to /dev/null.

> 
> Is there a mail list dedicated for UIO (userspace I/O)?

No, there's not enough mail traffic to justify that.

> I want to contribute to UIO but did not find the right
> mail list.

Please send your contribution to LKML and Cc: me and Greg
Kroah-Hartman. If you change an existing driver, also Cc:
the author of that driver.

Thanks,
Hans

