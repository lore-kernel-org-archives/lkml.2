Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab0HYPSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 11:18:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47634 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab0HYPSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 11:18:49 -0400
Message-ID: <4C753408.9010608@oracle.com>
Date: Wed, 25 Aug 2010 08:17:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Richard Hartmann <richih.mailinglist@gmail.com>
CC: linux-kernel@vger.kernel.org, kernelnewbies@nl.linux.org
Subject: Re: System silently not booting with 2.6.35 nor with 2.6.35.3 --
 It works fine with 2.6.32.x and 2.6.18.x
References: <AANLkTinzaRBaWX9EJTAt70Qk+bifFicUUGh=vRJaWL+N@mail.gmail.com> <AANLkTikQXxmzC1LxOC7wUWj40nRyLvBgGa0NO3_2s5oX@mail.gmail.com> <20100824104046.a8018469.randy.dunlap@oracle.com> <AANLkTinPLxZxOW70FtJBA3f4eG8kc-ju-G=UoATKV0qk@mail.gmail.com>
In-Reply-To: <AANLkTinPLxZxOW70FtJBA3f4eG8kc-ju-G=UoATKV0qk@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/10 04:52, Richard Hartmann wrote:
> On Tue, Aug 24, 2010 at 19:40, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> I would try enabling CONFIG_DEVTMPFS and CONFIG_DEVTMPFS_MOUNT.
> 
> As neiter the working nor the broken config has this option enabled, I
> don't know
> how this will help with finding the combinations of config options that made the
> kernel fail to boot. Unless I am missing something?

Is the "working" one the one that didn't find a root fs?
This could help with that, but I guess you said that wasn't a concern.

good luck on it.
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
