Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab1DRPsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 11:48:09 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55249 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab1DRPsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 11:48:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ii0G3/qAAmXiVACO359uIwuOXcLqOi0ZpFeHCZKMdm72N+dHN5sI70F6A7XIufDO14
         f6cS2qTcHGqA5qAwG8iK65Qld5hIPHnRpVzq9koqZHo5cqgc2fLVwqFS4SqSYSPl4f7W
         tOFw7vQGzwAKucEgF1ZfM7N9k2TLIBQrRLJ7U=
Message-ID: <4DAC5D2B.8000100@gmail.com>
Date: Mon, 18 Apr 2011 08:47:55 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Gottfried Haider <gottfried.haider@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        padovan@profusion.mobi
Subject: Re: [Regression] Bluetooth pairing does not work anymore in 2.6.39-rc3
 (works in 2.6.38.3)
References: <BANLkTi=LvyZ+7BHfVL849pztfvsYaVM4SQ@mail.gmail.com> <4DA9CB83.4050000@gmail.com> <BANLkTi=avo9yvpQ0VRPRv1uroF3ZnJzfAg@mail.gmail.com> <4DAA27C8.7060800@gmail.com> <BANLkTikihzxtp9ep3dE1zpPGKUGm1gij8Q@mail.gmail.com>
In-Reply-To: <BANLkTikihzxtp9ep3dE1zpPGKUGm1gij8Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2011 12:34 AM, Gottfried Haider wrote:
>>> I checked: I have this commit in -rc3, so it must be something else here.
>> hmm... seems to be working over here with the latest Mainline. one thing  I
>> have notice though is the daemon is not starting during boot(systemd),
>> manually starting bluetoothd gets me to connect.(system is fedora 15).
>
> It was my fault after all:
>
> I had based my kernel config on 2.6.39-rc2 from Ubuntu's
> mainline-kernel PPA, and this doesn't have BT_L2CAP..
>
> Case closed.
>

thats alright...(your human!!!)

>
> I am just wondering: is it possible to make BT_L2CAP (and SCO?)
> default to yes when BT is compiled in or build as a module?

tweaking the kconfig can do this.

>
>> From commit 6427451: "The L2CAP layer is needed by almost all
> Bluetooth protocols and profiles. There isn't any real use case
> without having L2CAP loaded." Yet when I am doing oldconfig from a
> config that had L2CAP build as a module, I am getting these easily
> overlooked lines:
>
> L2CAP protocol support (BT_L2CAP) [N/y/?] (NEW)
> SCO links support (BT_SCO) [N/y/?] (NEW)
>
>
> cheers,
> gohai
>

Justin P. Mattock
