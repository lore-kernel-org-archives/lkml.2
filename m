Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab0KIWQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:16:13 -0500
Received: from imr3.ericy.com ([198.24.6.13]:53606 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab0KIWQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:16:10 -0500
Subject: Re: [PATCH 04/11] hwmon: applesmc: Introduce a register lookup
 table (rev2)
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4CD9A1DC.2000407@euromail.se>
References: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
	 <1289315711-3011-5-git-send-email-rydberg@euromail.se>
	 <1289329469.22931.221.camel@groeck-laptop>  <4CD9A1DC.2000407@euromail.se>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Tue, 9 Nov 2010 14:15:26 -0800
Message-ID: <1289340926.22931.305.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Tue, 2010-11-09 at 14:32 -0500, Henrik Rydberg wrote:
[ ... ]
> 
> Changing the place of the mutex will ripple through all patches, so I will
> resend from this one onwards. I suppose you have more comments on the following
> patches?
> 
The other patches look ok to me.

Guenter


