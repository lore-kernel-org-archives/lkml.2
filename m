Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab0JDUX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:23:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42620 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322Ab0JDUX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:23:26 -0400
Message-ID: <4CAA379C.2050803@zytor.com>
Date: Mon, 04 Oct 2010 13:22:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "J.H." <warthog9@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: master - reboot
References: <4CAA2905.3090805@kernel.org> <20101004200430.GA17394@liondog.tnic>
In-Reply-To: <20101004200430.GA17394@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2010 01:04 PM, Borislav Petkov wrote:
> From: "J.H." <warthog9@kernel.org>
> Date: Mon, Oct 04, 2010 at 12:20:37PM -0700
> 
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> Afternoon everyone,
>>
>> We are going to do a quick reboot of the master backend server again in
>> about 2 hours at 2PM Pacific time or Mon Oct  4 21:00:00 UTC 2010.  This
>> is to fix the XFS reclaim bug that is currently present on the box.
>> Downtime should be less than 5 minutes.
> 
> This is probably unrelated but the tip-bot notifications are missing
> from lkml for a couple of days now. Any insight, Ingo, Peter?
> 
> Thanks.
> 

Looks like a stale lockfile.

	-hpa

