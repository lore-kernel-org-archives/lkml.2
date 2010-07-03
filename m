Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab0GCKPA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 06:15:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61998 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782Ab0GCKO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 06:14:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BH9RT2rAm4M1isbTZaZBEO/V6zGOtzMb+bYUgHO4Ms57b7IUrSF2kwrT62BF4JGkDF
         oWYIik0p0jWPgD0VAHn8N2LNDpyExyyhyLM54yySovk78yLgRDILwJKhgSe+mSKFj1BO
         12cgredOLZmddC0WgJUrPO0hrCiyKklncNTTM=
Subject: Re: [PATCH/RFC v2] hwmon: Add support for W83667HG-B and
 W83667HG-I to w83627ehf driver.
From: "=?gb2312?Q?=B1=F6=CE=F7=C3=C9?=" <binximeng@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
       Jim Cromie <jim.cromie@gmail.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ethan Lawrence <e.law87@yahoo.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, lars4910@hotmail.com,
       birdie@permonline.ru, jadcock@cox.net
In-Reply-To: <20100703103536.2fdd833e@hyperion.delvare>
References: <1278062606-29000-1-git-send-email-guenter.roeck@ericsson.com>
	 <20100703103536.2fdd833e@hyperion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 03 Jul 2010 12:15:48 +0200
Message-ID: <1278152148.7319.11.camel@xli51>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2010-07-03六的 10:35 +0200，Jean Delvare写道：
> Hi Guenter,
> 
> On Fri, 2 Jul 2010 02:23:26 -0700, Guenter Roeck wrote:
> > +    w83667hg-i   9      5       3       3      0xb340 0xc1    0x5ca3
> 
> As discussed before, this one is a 677 series, not 667. That being
> said, I admit that the device ID proximity between the 667HG-B and the
> 677HG-I is troubling, and invites to optimism as far as compatibility
> between these two chips is concerned.

I think we got something confused here, I was looking for the W836
*seven* 7 HG-I driver (which has ID 0xb470) and not the W836 *six* 7
HG-I one, although maybe someone else might benefit from that one.

It has at least 5 fans, with 3 pwm and 1 voltage regulatory. Using the
w83667hg driver, I can only see the speed of fan2 and fan3 in sensors
output. the w83627dhg-p already seems to read out 3 of the 5 fan speeds.
The temperatures seem rather wonky, I might need to compare with the
bios readings some more.

