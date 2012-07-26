Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab2GZILP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 04:11:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36007 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750867Ab2GZILM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 04:11:12 -0400
Date: Thu, 26 Jul 2012 09:11:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: arizona: Implement button detection support
Message-ID: <20120726081110.GA26373@opensource.wolfsonmicro.com>
References: <1342800449-10328-1-git-send-email-broonie@opensource.wolfsonmicro.com> <500F8DB4.30401@samsung.com> <20120725111105.GI3099@opensource.wolfsonmicro.com> <50108AE0.5070502@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50108AE0.5070502@samsung.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 09:10:08AM +0900, Chanwoo Choi wrote:

> If user press BTN_0 and BTN_1 at the same time and then user only
> released BTN_0 but BTN_1 is still pressed, is it right that report
> released event to all of buttons? I think that different event between
> BTN_0 and BTN_1.

That situation can't occur, the hardware can only detect one button at
once - if two buttons are pressed simultaneusly only one will be
reported.  This is just a standard resistive headset button detection
mechanism.
