Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab0HCTUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 15:20:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58016 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab0HCTUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 15:20:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=E358QsnNcOH3KyFbRhJ0i2GfHapynG0ex3fq35ypEvcbfzZRcH6Dk2zcz6vzE27Rw/
         XZ8OgtMpwfeiRxL+o4C2xtYWW+kqYWlBEUBxJ3P957ByVsyFUSz/LINAXs3KilzMm46r
         DT0LAKqc/tphobXPWxBZCSNYLw5HobFofkJkI=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Roberto Oppedisano <roberto.oppedisano@infracom.it>
Subject: Re: 2.6.35 suspend regression (bisected)
Date: Tue, 3 Aug 2010 21:20:42 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc6; KDE/4.4.4; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <4C4C9E40.7070209@infracom.it>
In-Reply-To: <4C4C9E40.7070209@infracom.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008032120.43421.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On niedziela, 25 lipca 2010 o 22:27:44 Roberto Oppedisano wrote:
> My HP6730B (x86_64 kernel, uptodate lubuntu Lucid installed) fails to
> suspend on recent git kernels, the screen goes black (backlight on) and
> stays there forever.
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16501
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
