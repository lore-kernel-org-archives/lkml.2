Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab2FIE1M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 00:27:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38427 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab2FIE1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 00:27:10 -0400
Message-ID: <4FD2CFE6.9070500@wwwdotorg.org>
Date: Fri, 08 Jun 2012 22:24:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dt: tegra: cardhu: register core regulator tps65911
References: <1337691917-15040-1-git-send-email-ldewangan@nvidia.com> <1337691917-15040-2-git-send-email-ldewangan@nvidia.com> <4FBBC192.7030900@wwwdotorg.org> <4FBBC830.2060802@nvidia.com> <4FBBCA8F.3050903@wwwdotorg.org> <4FBBD33C.8020802@nvidia.com> <4FBBDA97.6000006@wwwdotorg.org> <4FBBDE06.5080806@nvidia.com> <4FC916AC.4060804@wwwdotorg.org> <4FD250DB.2090207@nvidia.com> <20120609030608.GF3924@opensource.wolfsonmicro.com>
In-Reply-To: <20120609030608.GF3924@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2012 09:06 PM, Mark Brown wrote:
> On Sat, Jun 09, 2012 at 12:52:03AM +0530, Laxman Dewangan wrote:
> 
>> So is it fine to go on the above binding?
>> In this case we need to find the match_regulator based on
>> regulator-id rather than by name.
> 
> I guess.  I'm not enthusiastic about it (some way of using the key/value
> nature of DT as a hash would be much nicer) but it seems that the
> combination of DT and the existing code for it can't really give us
> more.  
> 
> If we're going to do this we need to update all the existing DT bindings
> for drivers that use single node regulators like this.  Please also
> change the name used for the property to regulator-compatible to make it
> clear that the idea is the same as normal compatible properties.

I'm not sure of the logic behind naming the property
"regulator-compatible"; the standard compatible property identifies that
the node is of a particular type/class, whereas the regulator-id in the
example Laxman quoted would indicate the specific identity/object. Those
seem like different things.
