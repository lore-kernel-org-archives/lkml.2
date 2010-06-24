Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab0FXTzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 15:55:50 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34864 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab0FXTzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 15:55:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=h0UawK3zsdc1jNZKWwpFQsULdv1rHbbdQqoLoiFkirM/eI2FHX7zzmIglDk8lum/8E
         PNuTraMSNKtQi/zlVKLe/Kbn7hWKApYu8xP/B/V5eDSQEsANYL5p5gcpGvfne6kOQlk9
         ge/3+5Bi43GoFjWny/IDrfaeCJQ/lRuEAftSc=
Message-ID: <4C23B877.4060209@lwfinger.net>
Date: Thu, 24 Jun 2010 14:56:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, mb@bu3sch.de, zajec5@gmail.com
Subject: Re: [PATCH 0/3] b43: logging cleanups
References: <cover.1276988387.git.joe@perches.com>	 <20100624185339.GC2368@tuxdriver.com> <1277408432.1654.80.camel@Joe-Laptop.home>
In-Reply-To: <1277408432.1654.80.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2010 02:40 PM, Joe Perches wrote:
> On Thu, 2010-06-24 at 14:53 -0400, John W. Linville wrote:
>> On Sat, Jun 19, 2010 at 04:30:08PM -0700, Joe Perches wrote:
>>> Just some small cleanups
>>> Joe Perches (3):
>>>   drivers/net/wireless/b43: Use local ratelimit_state
>>>   drivers/net/wireless/b43: Logging cleanups
>>>   drivers/net/wireless/b43: Rename b43_debug to b43_debugging
>> Any of the b43 guys want to express an opinion on these?
> 
> Stefano, are you active here?
> Your last ack for b43 was Feb 2008.
> There have been 400+ commits to b43 without your ack.
> 
> Should your name be moved from MAINTAINERS to CREDITS?
> 
> $ ./scripts/get_maintainer.pl --rolestats -f drivers/net/wireless/b43/
> Stefano Brivio <stefano.brivio@polimi.it> (maintainer:B43 WIRELESS DRIVER)
> "John W. Linville" <linville@tuxdriver.com> (maintainer:NETWORKING [WIREL...,commit_signer:204/240=85%)
> "Rafał Miłecki" <zajec5@gmail.com> (commit_signer:83/240=35%)
> "Gábor Stefanik" <netrolller.3d@gmail.com> (commit_signer:44/240=18%)
> Michael Buesch <mb@bu3sch.de> (commit_signer:39/240=16%)
> Larry Finger <Larry.Finger@lwfinger.net> (commit_signer:13/240=5%)
> linux-wireless@vger.kernel.org (open list:B43 WIRELESS DRIVER)
> netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
> linux-kernel@vger.kernel.org (open list)

The primary arbitrator for patches to the subtle parts of b43 is Michael
Buesch; however, he is no longer an official MAINTAINER. I can ACK some
things; however, any changes that are associated with my reverse
engineering of the Broadcom drivers are off limits.

Larry
