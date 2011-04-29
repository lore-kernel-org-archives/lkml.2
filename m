Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab1D2KuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 06:50:22 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51191 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486Ab1D2KuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 06:50:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pFDBRlUiA82PehHso9Tmtjqs7/5SJDL8rYNSXPltYIHpyGXUdRlAKYInQxcKXcUwCy
         eKn73zJUMxubVnocsSaDdXCin/GnhpIuZvvOhyiC/XCdulVDUShq94009udRD8WPtPBn
         UfAuM/31fRThybz52B8jvWqRiLHoBBCODwOBw=
MIME-Version: 1.0
In-Reply-To: <BANLkTinw9KJ5Awow5W6ASZ6ZWS6Hu7n7LA@mail.gmail.com>
References: <BANLkTinw9KJ5Awow5W6ASZ6ZWS6Hu7n7LA@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 29 Apr 2011 12:50:00 +0200
Message-ID: <BANLkTikDhhOW-sJ_iwxgzpDME9_XK-e8aQ@mail.gmail.com>
Subject: Re: EFF's Open Wireless Movement - solutions for Linux 802.11 APs
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, openwireless@eff.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 7:05 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> The EFF announced an effort and desire to promote open wireless
> networks instead of closed encrypted networks to help users with
> connectivity. They have come up with some alternative proposals and
> challenges which they are asking for review / help on. As far as Linux
> is concerned I've started a wiki [2] to cover what we can do for
> 802.11 Linux based APs. Feel free to extend the wiki as you see fit
> and / or subscribe for changes.
>
> [1] https://www.eff.org/deeplinks/2011/04/open-wireless-movement
> [2] http://wireless.kernel.org/en/developers/OpenWirelessMovement
>
>  Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

While everyone seems to be talking about people abusing your open
networks to download child porn, there is another issue: on an open
network, not only can everyone connect - any user can also snoop on,
and/or inject fake data into, any other user's communication.
The solution could be creating a modified version of WPA that does
encryption, but not authentication (i.e. lets anyone join the network,
but prevents one user from snooping on another one).

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
