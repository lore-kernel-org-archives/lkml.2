Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab2CFGjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 01:39:39 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62064 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab2CFGji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 01:39:38 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of tomoya.rohm@gmail.com designates 10.68.218.228 as permitted sender) smtp.mail=tomoya.rohm@gmail.com; dkim=pass header.i=tomoya.rohm@gmail.com
MIME-Version: 1.0
In-Reply-To: <1331002144-30113-1-git-send-email-tomoya.rohm@gmail.com>
References: <20120305164308.GE2459@kroah.com>
	<1331002144-30113-1-git-send-email-tomoya.rohm@gmail.com>
Date: Tue, 6 Mar 2012 15:39:37 +0900
Message-ID: <CANKRQng9mXsotS=Lq9QwwmXWEdfrwPUcTdxvjOf56uXe7APMiQ@mail.gmail.com>
Subject: Re: [PATCH][linux-next][RESEND] usb/gadget/pch_udc: Fix compile error
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Add information.

My develop environment is on x86.

According to following report,
  http://kisskb.ellerman.id.au/kisskb/buildresult/5771890/
  http://kisskb.ellerman.id.au/kisskb/buildresult/5771905/

This occurred on sparc64.

I suspect this issue ins GPIO implementation for sparc64.
Does sparc64 support GPIO interrupt ?
(Even x86, before 2.6.39, GPIO interrupt is not implemented !)

Additionally, this driver is for companion chip of Intel Atom E6xx series.
So, this driver is never used for except x86, e.g. sparc.

thanks
-- 
ROHM Co., Ltd.
tomoya
