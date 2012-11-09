Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab2KIVKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:10:35 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44609 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab2KIVKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:10:31 -0500
Message-ID: <509D7145.9000203@wwwdotorg.org>
Date: Fri, 09 Nov 2012 14:10:29 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>,
        Mark Zhang <markz@nvidia.com>
Subject: Re: [PATCH 0/2] Device tree updates for host1x support
References: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de> <509D3EB1.8040703@wwwdotorg.org> <20121109184409.GB7663@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121109184409.GB7663@avionic-0098.mockup.avionic-design.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 11:44 AM, Thierry Reding wrote:
> On Fri, Nov 09, 2012 at 10:34:41AM -0700, Stephen Warren wrote:
...
>> I really hope soon that Tegra will support DT bindings for clocks
>> so we can get rid of the AUXDATA, but unfortunately I haven't 
>> seen any movement towards this:-(
> 
> Oh yes, please. We wouldn't have any of the above problem if we
> had proper DT bindings for this. Who needs to be prodded to speed
> this up?

I believe one of Peter De Schrijver or Prashant Gaikwad are supposed
to be working on this.
