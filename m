Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab0DPOzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:55:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:16062 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0DPOzh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:55:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=WvCC2HoFtJF1mgXLJmxpQQ1zj6oa4gbs9sR/w0I6trQGuphX098YnAF+/V79pK6iqG
         OIt3GbvS9n+Pa9jpGWljpK/EWzdKz0z8YonbI7hBFqIB+47cN27FBZkp4sohjGqkrA21
         NGuJXjFSHQY9aa/70NcydX9w6odA+KeUTLy2I=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: =?iso-8859-1?q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
Subject: Re: [REGRESSION bisected] Sound goes too fast due to commit 7b3a177b0
Date: Fri, 16 Apr 2010 16:55:33 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3; KDE/4.3.4; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4BC4E812.6050602@tremplin-utc.net>
In-Reply-To: <4BC4E812.6050602@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004161655.33441.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 13 kwietnia 2010 o 23:54:26 Éric Piel wrote:
> Hello,
> 
> Since 2.6.34-rc*, I have a regression on alsa which prevents the sound
> to be played correctly. When playing, the music goes too fast, skipping
> some parts. Typically, it's very easy to reproduce by doing:
> time mplayer -endpos 30 sound-file-which-lasts-more-than-thirty-sec.mp3
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=15796
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
