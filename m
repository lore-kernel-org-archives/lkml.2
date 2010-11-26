Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab0KZW4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 17:56:46 -0500
Received: from 103.242.115-78.rev.gaoland.net ([78.115.242.103]:43509 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751855Ab0KZW4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 17:56:45 -0500
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Nov 2010 17:56:43 EST
Date: Fri, 26 Nov 2010 23:49:14 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Ben Hutchings <benh@debian.org>
Cc: Hayes Wang <hayeswang@realtek.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        564628@bugs.debian.org
Subject: Re: [PATCH] net/r8169: Correct the ram code for RTL8111D(L)
Message-ID: <20101126224914.GA12266@electric-eye.fr.zoreil.com>
References: <1290772470-23713-1-git-send-email-hayeswang@realtek.com>
 <1290779458.3051.45.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290779458.3051.45.camel@localhost>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <benh@debian.org> :
> On Fri, 2010-11-26 at 19:54 +0800, Hayes Wang wrote:
> > Correct the binary code (Low pass filter & DLY_CAP fine tune from uC).
> > The incorrect ram code would make the nic working abnormally.
> [...]
> 
> I'm glad you finally acknowledge that this is code rather than simple
> register initialisation.

I am not sure that Hayes is a native english speaker.

I am glad to see him posting here.

[...]
> Below are the changes Debian currently applies in preparation for proper
> licencing of the firmware.

Do you have some scripts to convert the data at hand ?

I would welcome a clear statement regarding the status of the binary thing
(code ? data ?) but even without one *now*, I'd like to see it separated
from the main code : the driver sucks and things will go worse with
support code for the 8168e.

Is there anybody objecting to it ? I will buy anything be it firmware API
or plain .h.

-- 
Ueimor
