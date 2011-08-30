Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab1H3RiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 13:38:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35045 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab1H3RiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 13:38:01 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Andreas Bombe <aeb@debian.org>
Subject: Re: Lockdep splat in sound core
Date: Tue, 30 Aug 2011 19:37:55 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc4; KDE/4.6.4; i686; ; )
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
References: <20110822232203.GA15492@amos.fritz.box>
In-Reply-To: <20110822232203.GA15492@amos.fritz.box>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108301937.55995.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 23 sierpnia 2011 o 01:22:04 Andreas Bombe wrote:
> The following lockdep splat occurs when the EMU10K1 driver is loaded. It
> actually did that for a long time already, it's about time I finally
> report it:
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 3.1.0-rc2-00171-gbed8cad #88
> ---------------------------------------------

[...]

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=42072
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
