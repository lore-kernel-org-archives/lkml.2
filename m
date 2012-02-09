Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab2BIMTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 07:19:32 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:57653 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756035Ab2BIMTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 07:19:30 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [RFC][PATCH 00/50] set addr_assign_type to NET_ADDR_RANDOM if a random mac address get assigned to a netdevice
Date: Thu, 9 Feb 2012 13:18:35 +0100
User-Agent: KMail/1.9.10
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de> <20120208.182942.1223790992368933837.davem@davemloft.net>
In-Reply-To: <20120208.182942.1223790992368933837.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201202091318.36264.danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328789970;749a665b;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Donnerstag, 9. Februar 2012, David Miller wrote:
> 50 patches is way too many patches to submit and expect people
> to review at one time.
>
> You must do one of two things:
>
> 1) Condense the series down to a smaller number of more managable
>    patches.  Perhaps combine all the completely trivial conversion
>    cases into one single patch, and post the non-trivial cases
>    seperately.
>
> 2) Only submit a few of these changes at a time, not all at once.
>
> It's your choice, but what you did here is unacceptable.

Could you at least comment on these points from the cover letter, before I 
change/update the patches?

- Should NET_ADDR_RANDOM get reset (to NET_ADDR_PERM) if the MAC address
  get changed via SIOCSIFHWADDR/.ndo_set_mac_address and was random before?
- Would it make sense to add a new state (e.g. NET_ADDR_USERSPACE)
  if the net address get changed via SIOCSIFHWADDR/.ndo_set_mac_address 
  from userspace?

Thanks,

Danny
