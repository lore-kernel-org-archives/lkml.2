Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab2JAVyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 17:54:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50639 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab2JAVyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 17:54:13 -0400
Message-ID: <506A10E4.80905@zytor.com>
Date: Mon, 01 Oct 2012 14:53:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Pierre Beck <mail@pierre-beck.de>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.6-rc7 32-bit PAE miscalculates dirty page limits
References: <5068130A.4050602@pierre-beck.de> <506894D5.5060101@zytor.com> <506A06B6.50800@pierre-beck.de> <20121001215202.GB19126@liondog.tnic>
In-Reply-To: <20121001215202.GB19126@liondog.tnic>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 02:52 PM, Borislav Petkov wrote:
> On Mon, Oct 01, 2012 at 11:10:47PM +0200, Pierre Beck wrote:
>> But what about other folks who upgrade their PC? They won't know what
>> hit them when their new PC crawls because disk is trashed.
> 
> I don't know, maybe backup their data, install a nice 64-bit Linux
> distro of their liking along with a 64-bit kernel which is several
> magnitudes more tested than its 32-bit counterpart, copy their data back
> and forget 32-bit ever existed...
> 

It is very sad, though, that there are still drivers which don't work
correctly in compat mode.  Please report bugs on those -- that is just
not acceptable.

Unfortunately few distros provide 64-bit kernels for their 32-bit
distros, which acerbates the problem.

	-hpa

