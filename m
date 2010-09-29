Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab0I2GPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 02:15:43 -0400
Received: from adelie.canonical.com ([91.189.90.139]:55806 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab0I2GPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 02:15:42 -0400
Message-ID: <4CA2D989.8050205@canonical.com>
Date: Wed, 29 Sep 2010 08:15:37 +0200
From: David Henningsson <david.henningsson@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100903 Thunderbird/3.1.3
MIME-Version: 1.0
To: =?UTF-8?B?RGllZ28gRWxpbyBQZXR0ZW7Dsg==?= <flameeyes@gmail.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: Band-aid solution for Dell Latitude E6410/E6510 microphone
References: <1285726141-26448-1-git-send-email-flameeyes@gmail.com>
In-Reply-To: <1285726141-26448-1-git-send-email-flameeyes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-29 04:09, Diego Elio Pettenò wrote:
> Hi all,
>
> I'm sending out a patch that I didn't write (and thus most likely require
> David's Signed-Off), but which I think might be a good idea to at least
> have accessible to search.
>
> As David already pointed out to me, the proper fix for the issue is
> Takashi's commit 75e0eb24ee3ec3549c2e53707dcc87e5f7a2c791, but that hasn't
> made it into .36 RCs and thus seem unlikely to come to users anytime soon.
>
> David's patch is a "band aid" solution; it solves most of the problem by
> adding one more special case to the sigmatel patches; on the other hand it
> makes the internal microphone to work fine on my laptop, which is a good
> thing, right?

It might also break docking station microphones on the same machines, 
which is why I thought it was no use trying to send it to stable. But if 
stable wants to add it, I'd be glad to give a sign-off or whatever 
necessary.

-- 
David Henningsson, Canonical Ltd.
http://launchpad.net/~diwic
