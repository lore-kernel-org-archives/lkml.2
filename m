Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab2G0CxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 22:53:05 -0400
Received: from mail-hostigation.familyross.net ([69.85.93.112]:35189 "EHLO
	mail.familyross.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab2G0CxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 22:53:03 -0400
Message-ID: <5012028C.9080107@familyross.net>
Date: Thu, 26 Jul 2012 19:53:00 -0700
From: Kevin Ross <kevin@familyross.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: David Dillow <dave@thedillows.org>
CC: Phil Turmel <philip@turmel.org>, linux-kernel@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>
Subject: Re: RAID extremely slow
References: <501078B2.8070707@familyross.net> <501096C3.5060700@turmel.org>   <5010A386.4080209@familyross.net>   <1343355303.29938.5.camel@obelisk.thedillows.org>  <1343355430.29938.6.camel@obelisk.thedillows.org>  <5011FA45.7030407@familyross.net> <1343356044.29938.7.camel@obelisk.thedillows.org>
In-Reply-To: <1343356044.29938.7.camel@obelisk.thedillows.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 07:27 PM, David Dillow wrote:
> On Thu, 2012-07-26 at 19:17 -0700, Kevin Ross wrote:
>> On 07/26/2012 07:17 PM, David Dillow wrote:
>>> On Thu, 2012-07-26 at 22:15 -0400, David Dillow wrote:
>>>> If you can, upgrade to the latest 3.4 stable kernel (3.4.6 right now).
>>>> As far as I can see, the latest 3.2 stable does not contain the delayed
>>>> stripe fix.
>>> And I was looking at the wrong version; 3.2.24 does indeed have the fix.
>>>
>> I'm running 3.2.21, does that contain the fix?
> No, that was the one I looked at. It is commit
> c0159c780e8d42309d04e83271986274d3880826.
>

Okay, I grabbed 3.4.4 from Debian experimental, and I'm running with 
that now.  Hopefully this fixes the problem.

Thanks for your help!
-- Kevin

