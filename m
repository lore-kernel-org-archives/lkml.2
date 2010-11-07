Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab0KGSVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 13:21:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57890 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab0KGSVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 13:21:45 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=kmBM95uMTtYA:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=yQdBAQUQAAAA:8 a=xq2IlzrEs7nJojogfygA:9 a=RcZ9BLeGPq0NOSeBcyUA:7 a=SycVzETQbOh20UrrLdCrD0UwR3oA:4 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Sun, 07 Nov 2010 12:22:18 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: florian.c.schilhabel@googlemail.com, jj@chaosbits.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] staging: r8712u: Remove unneeded local variables
Message-ID: <4cd6ee5a.R3D4fkob0gC+cK1h%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two cleanups for staging: r8712u

1. Remove extraneous variable from _malloc
2. Remove other extraneous variables from osdep_service.h

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

