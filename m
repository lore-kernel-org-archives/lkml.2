Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab2KIRbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:31:40 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:40848 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab2KIR2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:28:41 -0500
Message-ID: <509D3D46.7060102@wwwdotorg.org>
Date: Fri, 09 Nov 2012 10:28:38 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] spi: tegra: sequence compatible strings as per preference
References: <1352452052-13823-1-git-send-email-ldewangan@nvidia.com> <509D37B8.8020606@wwwdotorg.org> <20121109171008.GX23807@opensource.wolfsonmicro.com>
In-Reply-To: <20121109171008.GX23807@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 10:10 AM, Mark Brown wrote:
> On Fri, Nov 09, 2012 at 10:04:56AM -0700, Stephen Warren wrote:
> 
>> However just FYI, it should not be necessary for correctness; The
>> DT matching order is supposed to be driven purely by the order of
>> the compatible values in the DT now, and not affected by the
>> order of values in the table. (This wasn't always the case, but
>> was a bug that was fixed IIRC by Thierry Reding).
> 
> I guess the driver is being used backported in older kernels which
> don't have that fix?

That sounds likely. Laxman, it'd be a good idea to track down the fix
to the DT matching code and backport it, so that hard-to debug issues
aren't caused by the lack of that patch!
