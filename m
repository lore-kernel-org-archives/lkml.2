Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab1AUELy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 23:11:54 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44370 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab1AUELx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 23:11:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wpmsExv8KyNQdQP3OpbApk/lnOqZzueAIgj6dt5/aFm+Q/X5/yD88mSt6HVU8/fNHd
         B/Cmm8AY8W7OcGHB3eM5qXQVU1o/xSuzbH7rlI4PIPQ3W2Ibj6i8Hd1xJqO8fvDRbZuQ
         vdhXZCocq33ggN2AlmOMMO/siFYyMMw66eX1g=
Subject: Re: regression 2.6.37 -> 2.6.38-rc1: after suspend backlight
 cannot be adjusted
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20110121015529.GD9796@gamma.logic.tuwien.ac.at>
References: <20110121015529.GD9796@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 05:11:47 +0100
Message-ID: <1295583107.2613.45.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 21 janvier 2011 à 10:55 +0900, Norbert Preining a écrit :
> Hi everyone,
> 
> (please Cc)
> 
> going to 2.6.38-rc1 I see the following regression: After reboot I
> can easily adjust the backlight with the keys on my keyboard, but 
> after a suspend-to-ram this does not work anymore.
> 
> This is a Sony laptop, and backlight is controlled by the video
> acpi driver AFAIR.
> 

Hi Norbert

Maybe this is the problem Linus had to bisect, you could try his patch :

http://marc.info/?l=linux-netdev&m=129556877919576&w=2

Thanks !


