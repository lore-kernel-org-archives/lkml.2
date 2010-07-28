Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab0G1JiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 05:38:03 -0400
Received: from stallman.rootnode.net ([89.248.165.10]:47821 "EHLO
	stallman.rootnode.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab0G1Jh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 05:37:58 -0400
X-Greylist: delayed 1904 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jul 2010 05:37:58 EDT
Subject: Re: JPEG hw decoder
From: Pawel Moll <mail@pawelmoll.com>
To: rd bairva <rbairva@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTin4r_NrQbzXoTWoJJRCUXX9mjfgtrJ9yTPLW5_W@mail.gmail.com>
References: <AANLkTin4r_NrQbzXoTWoJJRCUXX9mjfgtrJ9yTPLW5_W@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 10:06:12 +0100
Message-ID: <1280307972.28571.12.camel@hornet.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>       My board has a hardware JPEG decoder. I want to write a driver
> for this in Linux kernel, But it seems there that no Framework exists
> in kernel. Can somebody provide me some pointers?

If I was to do the same, I'd look around V4L2 API. If covers things like
video encoders/decoders etc. The only problem is that the particular
area you are interested in is not well defined yet:

http://linuxtv.org/downloads/v4l-dvb-apis/ch04s05.html

This means that people usually extend the API in their own way, staying
within the framework itself, obviously.

Maybe you could ask about this on the linux-media mailing list?

http://vger.kernel.org/vger-lists.html#linux-media

Good luck!

Paweł

