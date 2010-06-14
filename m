Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab0FNLqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 07:46:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:45689 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab0FNLqE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 07:46:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vc/X7YwHWhxQR+1d1ZZTv496WZiyeu7Dcut7wNWOVjipxNXUbbh1CnQW5Ltebtg7rN
         fnkrGraqLAQD0wrDfLidWOrzqbkMRi36s53Wm2rKU1HvpNipJWfeJngPDRzf4R5dNjFc
         3J6uCCXO5lFJvzD6VEU/TIQlhLLBnsqYd5m90=
MIME-Version: 1.0
In-Reply-To: <AANLkTilu9_B8M_rcO7p1cUdZF1Hs99B6tpcMoETFrdgA@mail.gmail.com>
References: <AANLkTilu9_B8M_rcO7p1cUdZF1Hs99B6tpcMoETFrdgA@mail.gmail.com>
Date: Mon, 14 Jun 2010 13:46:02 +0200
Message-ID: <AANLkTil1e3kpxEnycuOxEXraBlR05aRYIF3FqC7FsIwq@mail.gmail.com>
Subject: Re: Ooops in iwl3945_bg_request_scan
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: ilw@linux.intel.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/10 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> Hi
>
>
> When I've switched  wifi killswitch on - to enable wireless - I've got
> following oops:
>
> NetworkManager: <info> WiFi now enabled by radio killswitch
> NetworkManager: <info> (wlan0): bringing up device.
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
> IP: [<ffffffffa029d90d>] iwl3945_bg_request_scan+0x56d/0xf00 [iwl3945]
> PGD 11f3c2067 PUD 127c1c067 PMD 0
> Oops: 0000 [#1] PREEMPT SMP
> last sysfs file: /sys/devices/platform/dock.0/flags
> CPU 0


I assume it is related to iwl bugzilla:

http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2208

Zdenek
