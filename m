Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab2IGTto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:49:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60141 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab2IGTtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:49:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 23/31] arm64: Debugging support
Date: Fri, 7 Sep 2012 19:49:39 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-24-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347035226-18649-24-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071949.39858.arnd@arndb.de>
X-Provags-ID: V02:K0:cFtV/iXSWizVfAQNcW4CVKMWDdR3Yz8MJHkbYQhp02Q
 EueuaTrpTxpxcYqCs9w5BtEjNGbNosVGC7pewIEWqeM762K5OL
 xxBVwRFVFzUF7MnxjQ98rgOGv6rvqi17a+rg+TvgNfrDeeYMoL
 7k4TmFLgkiGrGBL8/wKokwn2VHkHq0gb1M57kXDi1MAi8TJyK/
 vDAaL3I36yEUqt0o9bNPvIGnNMlWFDZexIP6pqLUdhCbO1YTX9
 aSiMyS/E8q+MaRTGFbYhF4VJcPtsecZ6G5f03hsq5tz2tbrEtf
 h1AVKj6mAO3WHqt6law0Y74FdEy6CioFia6Jx7JEKc4CJRyctb
 Ck2D8Dtw82U0ZrD425OQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Catalin Marinas wrote:
> From: Will Deacon <will.deacon@arm.com>
> 
> This patch adds ptrace, debug monitors and hardware breakpoints support.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Looks good to me now,

Acked-by: Arnd Bergmann <arnd@arndb.de>
