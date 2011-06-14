Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab1FNJI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 05:08:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:60280 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab1FNJIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 05:08:23 -0400
Subject: Re: [PATCH] ideapad: let Fn+F5 also trigger KEY_BLUETOOTH
From: David Woodhouse <dwmw2@infradead.org>
To: Ike Panhc <ike.pan@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Dmitry Torohov <dmitry.torokhov@gmail.com>
Date: Tue, 14 Jun 2011 10:08:20 +0100
In-Reply-To: <4DF71C01.6080504@canonical.com>
References: <1308040109-12038-1-git-send-email-ike.pan@canonical.com>
	 <4DF71C01.6080504@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 
Content-Transfer-Encoding: 7bit
Message-ID: <1308042502.3450.3.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 16:29 +0800, Ike Panhc wrote:
> I think it is better to solve this in driver not in user space application 
> because on some other platforms, the KEY_WLAN and KEY_BLUETOOTH are separate.

I think it's better to do it in userspace. It's not as if it's hard to
define another KEY_ and just tell the truth about what happened. Let
userspace work out what to do with it.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

