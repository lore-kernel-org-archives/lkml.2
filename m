Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab2FLVOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 17:14:11 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56664 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2FLVOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 17:14:10 -0400
Subject: Re: PROBLEM: Keyboard/mouse freeze with high network usage
 (r8169/brcmsmac/broadcom-wl)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Guillaume Bouchard <guillaume.bouchard@liris.cnrs.fr>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <CAGh0HCDhF_nKP+YKQDyfuYKcx2YKBuAPkMHxa0x265Rgs0haMg@mail.gmail.com>
References: <CAGh0HCDhF_nKP+YKQDyfuYKcx2YKBuAPkMHxa0x265Rgs0haMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jun 2012 23:14:05 +0200
Message-ID: <1339535645.22704.293.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 22:09 +0200, Guillaume Bouchard wrote:
> Dear kernel hackers,
> 
> The builtin keyboard and mouse of my laptop randomly freeze during usage.
> 
> It can happen on console or under X (for the mouse I'm not sure it
> freezes on console because I have no console mouse installed). But
> other parts of the computer are still perfectly alive (ie,
> applications continue to work, movie to play, computer can be reach by
> SSH).

If your script can trigger the freeze in less than 5 minutes, you could
start a background job to check /proc/meminfo, it sounds there is a mem
leak ?

while :
do
 date
 cat /proc/meminfo
 cat /proc/slabinfo
 sleep 10
done



