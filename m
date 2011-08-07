Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1HGSj1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 14:39:27 -0400
Received: from mout1.freenet.de ([195.4.92.91]:34320 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab1HGSjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 14:39:25 -0400
From: Andreas Hartmann <andihartmann@01019freenet.de>
X-Newsgroups: linux.kernel
Subject: Re: Linux 3.0: broken ums_eneub6250
Date: Sun, 07 Aug 2011 20:39:20 +0200
Organization: privat
Message-ID: <j1mm4l$55a$1@ID-44327.news.uni-berlin.de>
References: <hjXX6-Ee-55@gated-at.bofh.it> <hk6nE-6kT-5@gated-at.bofh.it> <hk7Wq-mZ-1@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110720 Firefox/5.0 SeaMonkey/2.2
In-Reply-To: <hk7Wq-mZ-1@gated-at.bofh.it>
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

obviously, nobody seems to be interested to work on this bug. Until it's
fixed: There is a workaround to get the device working again with 2.6.39
and 3.0 - just remove the unusable ums-eneub6250.ko and replace it with
the complete old and fine keucr-module - staging but working :-)

https://bugzilla.novell.com/show_bug.cgi?id=709243#c1


Andreas
