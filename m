Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab1D1SPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 14:15:22 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61857 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876Ab1D1SPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 14:15:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tmsXcfM30/tTa7VS0WAJ8XHENeZ8zggIuPlOxJ1WVGa1qSoadgrcENgoL4W1GOb+Xr
         0zxYVDQ9Nh6sAg4pzNCR/U+k0UpyPu5qqkkvcVpO24zdq2OTdj88B7vo+kkh3qxoPZVR
         NiWqa2t1j8ADqyYAzCmQa1Dz/JlIe3+zYj9EE=
Message-ID: <4DB9AEB2.4000807@lwfinger.net>
Date: Thu, 28 Apr 2011 13:15:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, openwireless@eff.org
Subject: Re: EFF's Open Wireless Movement - solutions for Linux 802.11 APs
References: <BANLkTinw9KJ5Awow5W6ASZ6ZWS6Hu7n7LA@mail.gmail.com>
In-Reply-To: <BANLkTinw9KJ5Awow5W6ASZ6ZWS6Hu7n7LA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2011 12:05 PM, Luis R. Rodriguez wrote:
> The EFF announced an effort and desire to promote open wireless
> networks instead of closed encrypted networks to help users with
> connectivity. They have come up with some alternative proposals and
> challenges which they are asking for review / help on. As far as Linux
> is concerned I've started a wiki [2] to cover what we can do for
> 802.11 Linux based APs. Feel free to extend the wiki as you see fit
> and / or subscribe for changes.

There is no doubt that the EFF means well; however, there is one situation that 
they seem to ignore. If any part of my AP is unencrypted and some outsider uses 
it to download child pornography, the IP address in any server logs is mine. If 
the authorities recover those logs as part of a criminal investigation and 
investigate the clients, they will immediately come to me. How do I prove that I 
am innocent of the porno charge and only guilty of being a good citizen and 
providing wireless access to the public? I do not relish the thought of becoming 
a registered sex offender.

Of course, I could add a strong web filter to my Internet access, but that is an 
expense in time and money that I would prefer to avoid as only my wife and I use 
the connection. I trust her, and I think she trusts me.

Yes, my WPA2 link is not completely secure, but my 28-character, non-dictionary 
pass phrase is hard to crack.

Larry
