Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab0DITKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:10:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:32284 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab0DITKN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:10:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=OKCMySSE7h985Ust/vwaGmEZiv8Rq8JZyvBKfylgxi8UUFx1rdqh6z/FwxBVuEIK66
         srTQNvYxSWUpoyjCfUsUI2N6DSdJfddt8FKC0cQwl8ukFz2ym6aqztEolLcDML78t/Tm
         Q3ZhWzaui1nqvlinUlxviGZ+xVaR+6yedRknc=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Andy Isaacson <adi@hexapodia.org>
Subject: Re: [2.6.34-rc1 REGRESSION] ahci 0000:00:1f.2: controller reset failed (0xffffffff)
Date: Fri, 9 Apr 2010 21:10:09 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20100406225425.GA8292@hexapodia.org>
In-Reply-To: <20100406225425.GA8292@hexapodia.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004092110.09325.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 7 kwietnia 2010 o 00:54:25 Andy Isaacson wrote:
> This Dell Precision WorkStation T3400 doesn't boot 2.6.34-rc1 (tried
> 522dba71).  2.6.33 was fine, and it's been running various stable
> kernels for the last 18 months.  Unfortunately I can't reasonably bisect
> as I need this machine to be usable, but I can test specific patches or
> options.  (three or four reboots is fine, 15 is not.)
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=15744
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
