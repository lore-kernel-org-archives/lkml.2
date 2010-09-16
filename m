Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab0IPUGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 16:06:01 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60385 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab0IPUF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 16:05:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=rUxeiYwqldNXf91rvG+YHqjWY9xZ3S7QCpvvC1yFCB7Vlvd5T6szNY4RO1rn4gruad
         uFmvmUnpZl05p4slZNoUDrf0bR3L/lN0FqOv6uYJuA1XI9gdzN+9ywmCsNqy+U+nMqSN
         qJ1mxyy1s4Y3ULfMqj3pTudCGqBpVP5BK6x/Y=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: 2.6.36-rc4/iwl: warning triggered in net/mac80211/scan.c:266
Date: Thu, 16 Sep 2010 22:05:53 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        "Wey-Yi Guy" <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>
References: <20100914142814.GA8744@redhat.com>
In-Reply-To: <20100914142814.GA8744@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009162205.54034.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 14 września 2010 o 16:28:15 Michael S. Tsirkin wrote:
> I am running 2.6.36-rc4 on T60 with an iwlagn wireless card:
> 03:00.0 Network controller: Intel Corporation PRO/Wireless 5100 AGN
> [Shiloh] Network Connection
> 
> I was compiling a large file which stressed the box heavily, and the
> following warning in net/mac80211/scan.c triggered:

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=18692
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
