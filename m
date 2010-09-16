Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab0IPQys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 12:54:48 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33951 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753491Ab0IPQyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 12:54:46 -0400
X-Sasl-enc: cXoPjyKJu+IdOQTPJc9b2BkfzVFaHfPIl2U6jiF+jBbu 1284656085
Date: Thu, 16 Sep 2010 13:54:41 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jean Delvare <khali@linux-fr.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH 1/2] hwmon: (adm1031) Replace update_rate
 sysfs attribute with update_interval
Message-ID: <20100916165441.GA11371@khazad-dum.debian.net>
References: <1284602835-7605-1-git-send-email-guenter.roeck@ericsson.com>
 <1284602835-7605-2-git-send-email-guenter.roeck@ericsson.com>
 <20100916171443.0322bdb6@hyperion.delvare>
 <20100916154243.GB25145@khazad-dum.debian.net>
 <20100916180112.2ce29d2a@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916180112.2ce29d2a@hyperion.delvare>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010, Jean Delvare wrote:
> > I'd rather have it in Hz, actually.  I consider that more user-friendly.
> > But that's just personal preference.
> 
> The problem with Hz is that we need to be able to handle values lower
> than 1, and mHz as a unit isn't exactly friendly. I would be very fine
> with Hz (especially as we use it for pwmN_freq already) if we didn't
> have to support frequencies below 1 Hz. For such low frequencies,
> period (or interval) is clearer than frequency IMHO.

We can always use fixed point math... ;-)

I am kidding, I am perfectly aware it is not worth the trouble.

And I agree with you, mHz would be horrible as far as usability goes.  And
prone to be confused with MHz, too.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
