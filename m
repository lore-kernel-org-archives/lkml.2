Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab0HSPLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:11:34 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65533 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab0HSPLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:11:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=kL+iM6E4LOzjr1IJnkHslTHsqqgtldsuIzFd+1YCBg11VRfxyCJPQzXiYh+LcLhube
         v8WB7FAm6qGUfO/R+vw7voPkMwUG/glvVFiMJKEJM7OP9ETxPXl/viAwO3P2Okr4MKbC
         obCpPJ22Eu3VAPtF7PIDVf5nMAJn1xanarI/I=
From: Gene Heskett <gene.heskett@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG raid1] kernel BUG at drivers/scsi/scsi_lib.c:1113
Date: Thu, 19 Aug 2010 11:11:27 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35.2; KDE/4.5.0; i686; ; )
References: <20100817220917.GA5268@Krystal> <4C6C9E10.9030202@fusionio.com> <1282229572.8139.16.camel@mulgrave.site>
In-Reply-To: <1282229572.8139.16.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008191111.27323.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 19, 2010, James Bottomley wrote:
[...] 
>> > Certainly sir ... and would you like your patches served to your
>> > table or by the pool?
>> 
>> Pool, please. With that first name and the British accent, it's hard
>> not to boss you around.
>
>Well, sir, the wait staff and I thought we'd just write to ask how your
>convalescence was going.  Sorry about spilling the patch down your
>front, sir, but the glass was slippery.  Who could have foreseen that
>you'd step backwards, fall over the pool boy and upset a flaming bananas
>foster on to the front of your shorts.  I did get a commendation for my
>quick action with a high pressure hose to the affected area (thank you,
>sir, for your shocked but grateful expression).  I must say I didn't
>foresee the force of the blast catapulting you against the pool steps,
>but a concussion is a small price to pay for avoiding fried nuts with
>the bananas, eh, sir? It's funny how things turn out, and I bet if you
>could do it over again, you'd have got off your arse to fetch your own
>damn patch now, wouldn't you, sir?
>
>Yours sincerely,
>
>James

You guys are priceless, thanks for the belly laugh.  Lightens up my whole 
days it does.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Portability should be the default.
             -- Larry Wall in <199711072201.OAA01123@wall.org>
