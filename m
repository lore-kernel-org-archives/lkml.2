Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab1AQVwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 16:52:00 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43903 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab1AQVv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 16:51:58 -0500
Message-ID: <4D34B9F9.6060606@canonical.com>
Date: Mon, 17 Jan 2011 22:51:53 +0100
From: David Henningsson <david.henningsson@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avinash Kurup <kurup.avinash@gmail.com>
CC: tiwai@suse.de, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: ALSA: Sound barely audible since 2.6.37-rc1+
References: <AANLkTinpBCweL8cvjaA1m0WpeqSkbXy9ZkNrvbJwXGg6@mail.gmail.com>
In-Reply-To: <AANLkTinpBCweL8cvjaA1m0WpeqSkbXy9ZkNrvbJwXGg6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-17 16:24, Avinash Kurup wrote:
> Hi Takashi,
>
> The sound on my computer since 2.6.37-rc1+ is barely audible (extremely
> soft), The sound
> remains the same even on increasing it on the desktop or the application.
>
> On accessing alsa-mixer I get the error, cannot load mixer controls:
> Invalid argument.
>
> I bisected the problem to this commit.
> 03b7a1ab557efe34e8f79b78660e514bd7374248 is the first bad commit
> commit 03b7a1ab557efe34e8f79b78660e514bd7374248

This patch was actually dropped (see 
625787b760b920234ba9736a1ef85297e1bfa110 ) in favour of 
01e0f1378c47947b825eac05c98697ab1be1c86f (ALSA: hda - Fixed ALC887-VD 
initial error).

-- 
David Henningsson, Canonical Ltd.
http://launchpad.net/~diwic
