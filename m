Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab1BBXCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 18:02:43 -0500
Received: from stinky.trash.net ([213.144.137.162]:44570 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab1BBXCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 18:02:41 -0500
Message-ID: <4D49E28F.2020203@trash.net>
Date: Thu, 03 Feb 2011 00:02:39 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Randy Dunlap <randy.dunlap@oracle.com>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvs-devel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Hans Schillstrom <hans@schillstrom.com>
Subject: Re: [GIT PULL nf-next-2.6] IPVS build fixes and clean-ups
References: <1296519255-10602-1-git-send-email-horms@verge.net.au> <20110131165009.66999952.randy.dunlap@oracle.com> <20110201040634.GA2351@verge.net.au> <20110201100421.GA13325@verge.net.au> <4D483D6E.5070007@oracle.com> <4D4840BC.4050303@trash.net> <20110202213907.GI2248@verge.net.au>
In-Reply-To: <20110202213907.GI2248@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.02.2011 22:39, schrieb Simon Horman:
> On Tue, Feb 01, 2011 at 06:19:56PM +0100, Patrick McHardy wrote:
>> Thanks, since Simon is travelling, I'll apply the patches now
>> with your and Hans's Acks and will push them to Dave later.
> 
> Thanks, I've finished travelling now :-)
> 

The patches got delayed a bit due to a build error in nf-next,
but I'll send them to Dave shortly.
