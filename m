Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab2HPS53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:57:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41858 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab2HPS5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:57:24 -0400
Message-ID: <502D428F.1010901@wwwdotorg.org>
Date: Thu, 16 Aug 2012 12:57:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 1/3] Runtime Interpreted Power Sequences
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com> <1345097337-24170-2-git-send-email-acourbot@nvidia.com> <502D3E29.1010501@wwwdotorg.org> <20120816184703.GP15365@opensource.wolfsonmicro.com>
In-Reply-To: <20120816184703.GP15365@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 12:47 PM, Mark Brown wrote:
> On Thu, Aug 16, 2012 at 12:38:33PM -0600, Stephen Warren wrote:
> 
>> Note that this somewhat conflicts with accessing the top-level power
>> sequence by name too; perhaps that should be re-thought too. I must
>> admit this DT rule kinda sucks.
> 
> Given that currently the information there is useless and ignored is
> there any reason we can't just change the rule?  It'd be rather more
> constructive...

I'll start a new thread on that topic and see. I would simplify matters
a lot...

