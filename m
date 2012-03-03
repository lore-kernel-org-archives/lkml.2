Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab2CCWH4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 17:07:56 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54724 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab2CCWHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 17:07:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of chunkeey@googlemail.com designates 10.14.37.203 as permitted sender) smtp.mail=chunkeey@googlemail.com; dkim=pass header.i=chunkeey@googlemail.com
From: Christian Lamparter <chunkeey@googlemail.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH] pcmcia: move unbind/rebind into dev_pm_ops.complete
Date: Sat, 3 Mar 2012 23:07:49 +0100
User-Agent: KMail/1.13.7 (Linux/3.3.0-rc4-wl+; KDE/4.6.5; x86_64; ; )
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201203032111.29558.chunkeey@googlemail.com> <20120303220117.GA9247@isilmar-3.linta.de>
In-Reply-To: <20120303220117.GA9247@isilmar-3.linta.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203032307.49583.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 March 2012 23:01:17 Dominik Brodowski wrote:
> This is patch 2/6 of which series? Does this depend upon other patches which
> are not yet in mainline?
please ignore the 2/6. I just haven't used git format-patch for a while ;).

But if you want to know, the other patches are not directly related to pcmcia.

"[RFC] firmware loader: retry _nowait requests when userhelper is not yet "
https://lkml.org/lkml/2012/3/3/102

[PATCH 1/2] p54: pass interface setup errors back to mac80211
http://marc.info/?l=linux-wireless&m=133080632610608

[PATCH 2/2] p54pci: use new driver.pm interface for suspend/resume
http://marc.info/?l=linux-wireless&m=133080636210610

[RFT 1/2] p54pci: convert driver to use asynchronous firmware loading
http://marc.info/?l=linux-wireless&m=133080766810882

[RFT 2/2] p54: only unregister ieee80211_hw when it has been registered
http://marc.info/?l=linux-wireless&m=133080767110883

Regards,
	Christian
