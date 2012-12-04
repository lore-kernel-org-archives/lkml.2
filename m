Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab2LDILV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 03:11:21 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53708 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2LDILT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 03:11:19 -0500
Message-ID: <50BDB016.7010908@ti.com>
Date: Tue, 4 Dec 2012 09:11:02 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Bryan Wu <cooloney@gmail.com>
CC: Richard Purdie <rpurdie@rpsys.net>, <linux-leds@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v2 1/3] leds: leds-pwm: Convert to use devm_get_pwm
References: <1352731270-27534-1-git-send-email-peter.ujfalusi@ti.com> <1352731270-27534-2-git-send-email-peter.ujfalusi@ti.com> <CAK5ve-JDCSSOKHQG-F1RoDii62=-DiPevaD6SafndYVvOgB6Fw@mail.gmail.com> <50BCB391.1070305@ti.com> <CAK5ve-+1eQ3mPLAu2Qxw4LjNA85oEtJE-wZcL=YpQ0xBFJ6+hQ@mail.gmail.com>
In-Reply-To: <CAK5ve-+1eQ3mPLAu2Qxw4LjNA85oEtJE-wZcL=YpQ0xBFJ6+hQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On 12/03/2012 07:32 PM, Bryan Wu wrote:
> On Mon, Dec 3, 2012 at 6:13 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> Actually, I'm waiting for some feedback from DT maintainers about this
> new binding. But it looks find to me.

Would it be possible to have the first (or even better the first two) patch
going for 3.8 and we can leave the DT bindings for 3.9?
I would like to clean up, fix some of the OMAP related board files for 3.9
which would need the patches for the leds-pwm driver itself.

Thank you,
Péter
