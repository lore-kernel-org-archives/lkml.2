Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab1H3RsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 13:48:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40747 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab1H3RsG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 13:48:06 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Dave Jones <davej@redhat.com>
Subject: Re: 3.1.0-rc2 block related lockdep report.
Date: Tue, 30 Aug 2011 19:48:02 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc4; KDE/4.6.4; i686; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, jaxboe@fusionio.com
References: <20110819215754.GA12746@redhat.com>
In-Reply-To: <20110819215754.GA12746@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201108301948.02553.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On piątek, 19 sierpnia 2011 o 23:57:54 Dave Jones wrote:
> Just got this while running kvm. (this is from the host)
> 
> 	Dave
> 
> =================================
> [ INFO: inconsistent lock state ]
> 3.1.0-rc2+ #139
> ---------------------------------
[...]

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=42082
for your bug report, please add your address to the CC list in there, thanks!
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
