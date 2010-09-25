Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab0IYR1R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 13:27:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:53045 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab0IYR1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 13:27:16 -0400
Date: Sat, 25 Sep 2010 10:24:59 -0700
From: Greg KH <gregkh@suse.de>
To: Piotr Hosowicz <piotr@hosowicz.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [00/80] 2.6.35.6 stable review
Message-ID: <20100925172459.GA2208@suse.de>
References: <20100924162706.GA7381@kroah.com> <4C9E2801.4020609@example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C9E2801.4020609@example.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 06:49:05PM +0200, Piotr Hosowicz wrote:
> On 24.09.2010 18:27, Greg KH wrote:
>
>> This is the start of the stable review cycle for the 2.6.35.6 release.
>> There are 80 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let us know.  If anyone is a maintainer of the proper subsystem, and
>> wants to add a Signed-off-by: line to the patch, please respond with it.
>>
>> Responses should be made by Sunday September 26, 17:00:00 UTC
>> Anything received after that time might be too late.
>
> nouveau graphics driver does not work at all. I submitted full data a few 
> days ago.

Was that with .5 or is this something new for .6?  And sorry if I missed
this, for some reason I thought the problem was with the nvidia driver.

If it showed up in .5 can you bisect to see what the problem patch was?

thanks,

greg k-h
