Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1BBU2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:28:20 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52406 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab1BBU2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 15:28:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=LCYZ5mA/7VMxumyHj66/xxT3WFJmG7KbJa/0ruhfO/oq4X/Ib9nor8qOveUmGmgUN2
         IIBd4O2tz7ggquKfkvEgnEw/paLT/aI7uMzGuFhlf1yA0kBt6WubngVu9SS0ClLyDXXs
         HE1BjvBT+ytvqc/+03JvaFGiY/AC+ebj0nZIc=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Nico Schottelius <nico-kernel-20110117@schottelius.org>
Subject: Re: New display errors in 2.6.38-rc2-00175-g6fb1b30
Date: Wed, 2 Feb 2011 21:28:12 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2; KDE/4.4.5; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20110128202905.GB3395@schottelius.org>
In-Reply-To: <20110128202905.GB3395@schottelius.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201102022128.12589.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On piątek, 28 stycznia 2011 o 21:29:05 Nico Schottelius wrote:
> Hey hackers!
> 
> With 2.6.38-rc2-00175-g6fb1b30 I get a new version of broken
> display I've never seen before: The display looks like a misconfigured
> tv after 2-3 suspends. Switching to a different tty was possible (though
> still same broken display, but allowed a reboot) one time, the other time
> the system completly froze.
> 
> 2.6.37, 2.6.37-05761-gf878133 and 2.6.37-07956-g8c34482 do not have this
> bug.
> 
> Cheers,
> 
> Nico
I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=28102
for your bug report, please add your address to the CC list in there, thanks!
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
