Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab0LITSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 14:18:08 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:50112 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab0LITSG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 14:18:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=GqpI9MhURxrBqPfM31zXQImQM1Tz7J1sjB9S2prx1PvEWZHNheNs93Z+NsLl/7SL8L
         UHjCkBJfrqvmkLj3AbVfjo1ytR44a+P6cMMr3aHWBgTBXwRWw4puKZ+Au69TiExL8EMb
         gvkoSU3Gx3F9FTWN85l6Bx8tSjTisonNezCYQ=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "baoyb" <baoyb@avit.org.cn>
Subject: Re: Kernel Oops at tty_buffer_request_room when using pppd program (2.6.37-rc4)
Date: Thu, 9 Dec 2010 20:17:59 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, alan@linux.intel.com
References: <EF6DDE218DB34702B1FA84D6CD7EA771@baoyb>
In-Reply-To: <EF6DDE218DB34702B1FA84D6CD7EA771@baoyb>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201012092018.00201.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 8 grudnia 2010 o 14:55:09 baoyb wrote:
> Hi All:
> 
> We are using a USB 3G card(HUAWEI e180) and wvdial+pppd(version 2.4.5)
> program. Sometimes kernel will crash when pppd disconnect the link. Our cpu
> platform is AMCC ppc405EX and kernel version is 2.6.37-rc4.
> The following is log info when oops happened.
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=24582
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
