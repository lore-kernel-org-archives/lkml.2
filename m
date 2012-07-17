Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab2GQOU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 10:20:29 -0400
Received: from smtp-out-164.synserver.de ([212.40.185.164]:1105 "EHLO
	smtp-out-164.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab2GQOU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 10:20:26 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 27531
Message-ID: <50057593.3050808@metafoo.de>
Date: Tue, 17 Jul 2012 16:24:19 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/8] regmap: Add the indexed cache support
References: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com> <1314978375-11539-3-git-send-email-dp@opensource.wolfsonmicro.com> <4E613986.4040007@metafoo.de> <20120717111635.GA27595@sirena.org.uk>
In-Reply-To: <20120717111635.GA27595@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2012 01:16 PM, Mark Brown wrote:
> On Fri, Sep 02, 2011 at 10:16:06PM +0200, Lars-Peter Clausen wrote:
> 
>> I have some patches for the rbtree register cache code, which reduce some of
>> it's complexity and also implements the adjacent node merging and allows
>> smaller holes in the rbnodes register block if the block is smaller then an
>> rbnode. Currently these patches are based on the ASoC register cache code, but
>> they should be easy to rework onto of the regmap register cache code.
> 
> Dimitris just reminded me about what you said here - do you still have
> those patches floating around?  This would really useful and would
> make some other optimistations like not cacheing default values much
> easier.

Yes, I still have it, but it's on a machine which is currently broken and I
wont get the replacement part until next week.

- Lars
