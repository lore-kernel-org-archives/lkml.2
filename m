Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab1JQMv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 08:51:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54851 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab1JQMv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 08:51:28 -0400
Date: Mon, 17 Oct 2011 14:51:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: =?iso-8859-1?Q?=A0?= <porpen@gmail.com>
Cc: Tarkan Erimer <tarkan.erimer@f-secure.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: finger service @ftp.kernel.org
Message-ID: <20111017125126.GB18822@gere.osrc.amd.com>
References: <4E9BE18B.5070803@f-secure.com>
 <CAANzHtS8kCTBkHUwxN_s9ZucrkXHyUvzFzAN7TA7K_XGgiKwxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAANzHtS8kCTBkHUwxN_s9ZucrkXHyUvzFzAN7TA7K_XGgiKwxA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 05:03:07AM -0400,   wrote:
> The finger_banner page appears to be current,

It doesn't look like it here:

$ curl http://kernel.org/kdist/finger_banner
...
The latest snapshot 3 version of the Linux kernel is:         3.1-rc4-git2
The latest mainline 3 version of the Linux kernel is:         3.1-rc4

...

$ date
Mon Oct 17 14:50:59 CEST 2011


-- 
Regards/Gruss,
Boris.
