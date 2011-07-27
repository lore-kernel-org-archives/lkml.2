Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab1G0R5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 13:57:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49173 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab1G0R5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 13:57:42 -0400
Date: Wed, 27 Jul 2011 19:57:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
Subject: [Q] compiler no longer warning about undeclared struct?
Message-ID: <Pine.LNX.4.64.1107271947490.7435@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:snJLhXM/0GpGtijKIZRB2XXUYWCQgxBtzPPEdNcFqtA
 owixCnq8FGln3Baf3oSk9BBM7pUDaV86SBNdx8ibNS3KIti6Y6
 A2hdgvo4BS+f0vEx4Hxz8UgUnfF+WdyXi+eHF9ap5113ovg9h9
 Bro4mxU0bETjYyDgMl8UDNYrwd1kVeOmp2HbHyXymsFSgrIYMX
 TfEXuOabOrZ6VCacG3hpEqTwbKCRtTl/4nyUnNZ7N0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I just ran across a driver in the kernel (drivers/media/video/ov2640.c, 
struct ov2640_priv::info), that does something like

struct xx {
	struct yy *y;
};

static void z(void)
{
	struct xx *x;
	void *p;

	x = ...;
	p = ...;
	x->y = p;
}

where "struct yy" is nowhere declared, and the compiler happily swallows 
this... Shouldn't it complain? Didn't it complain before?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
