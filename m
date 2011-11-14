Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1KNIKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 03:10:51 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.38]:41652 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1KNIKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 03:10:47 -0500
Message-ID: <4EC0CD04.4090107@ladisch.de>
Date: Mon, 14 Nov 2011 09:10:44 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Klaus Ripke <klaus@ripke.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: LOAD_FREQ (4*HZ+61) avoids loadavg Moire
References: <20111112143825.GX6192@aine.Speedport_W_502V_Typ_A>
In-Reply-To: <20111112143825.GX6192@aine.Speedport_W_502V_Typ_A>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Klaus Ripke wrote:
> With some seconds based load (like SSL heartbeats)
> and LOAD_FREQ at (5*HZ+1) I see Moire patterns like inverse sawtooth,

Thanks for researching this, but I don't see them because I'm too lazy
to reproduce this.  Could you please publish a colorful screenshot
somewhere?

> I suggest (4*HZ+61) for a better distribution.

It appears your attached patch got lost somehow.  ;-)


Regards,
Clemens
