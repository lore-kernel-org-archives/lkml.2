Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab2LQW3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:29:45 -0500
Received: from unix.wroclaw.pl ([94.23.28.62]:46065 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab2LQW3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:29:43 -0500
X-Greylist: delayed 1320 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2012 17:29:43 EST
Date: Mon, 17 Dec 2012 23:07:38 +0100
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/27] 3.7.1-stable review
Message-ID: <20121217220738.GA3542@mako-laptop>
References: <20121214222251.229078963@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121214222251.229078963@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on unix.wroclaw.pl
	Spam=No score=-1.4 bayes=0.5 autolearn=disabled
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 03:01:13PM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.7.1 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun Dec 16 22:16:56 UTC 2012.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.7.1-rc1.gz
> and the diffstat can be found below.

Greg, would that be a problem to send these patches for review to
linux-3.7.y branch and mark them with v3.7.1-rc1 commit/tag? Is something goes
wrong there is still place to fix/revert as needed. If not do the final
commit/tag that says this is v3.7.1 [1].

It would be easier to automate things by just monitoring linux-stable
remote for new tags.

[1] linux-3.7.y is just an example here

Regards,
-- 
Mariusz Kozlowski
