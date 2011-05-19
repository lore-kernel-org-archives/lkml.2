Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab1ESM5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:57:05 -0400
Received: from sparky.wurtel.net ([81.171.37.211]:45077 "EHLO mx.wurtel.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401Ab1ESM5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:57:04 -0400
X-Greylist: delayed 1934 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 May 2011 08:57:04 EDT
Date: Thu, 19 May 2011 14:24:37 +0200
From: Paul Slootman <paul@wurtel.net>
To: linux-kernel@vger.kernel.org
Cc: tsuckow@gmail.com
Subject: Re: PROBLEM: Freeze till mouse moved or key pressed
Message-ID: <20110519122437.GA1382@msgid.wurtel.net>
Mail-Followup-To: linux-kernel@vger.kernel.org, tsuckow@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=kHfbTGLPs+rsws0hrOaHs5HpeQw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Wurtel-Bad-Headers: Message headers fail syntax check
X-Wurtel-No-Sender: No verifiable sender address in message headers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> System freezes till mouse moved or key pressed.

I've notice something similar on 2.6.35.3 kernels,
it had to do with HPET timers (I think) not working correctly.
Upgrading the kernel to 2.6.37 fixed it for us.


Paul
