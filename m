Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab1GFWUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 18:20:10 -0400
Received: from lo.gmane.org ([80.91.229.12]:56727 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab1GFWUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 18:20:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tech <getler1010@gmail.com>
Subject: Re: kmemcheck error and panic when booting 2.6.39.1 , however acpi=off allows to boot
Date: Wed, 6 Jul 2011 22:13:09 +0000 (UTC)
Message-ID: <loom.20110707T000722-219@post.gmane.org>
References: <4DEA8FDD.1060905@elektron.elka.pw.edu.pl> <4DEAA677.2010404@elektron.elka.pw.edu.pl> <4DEAAB42.8070704@elektron.elka.pw.edu.pl> <4DEB4EF2.5050102@elektron.elka.pw.edu.pl> <4DEBE579.1070508@ise.pw.edu.pl> <4DF3885B.2080900@ise.pw.edu.pl> <4DF3949F.9070901@ise.pw.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 69.242.243.1 (Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20100101 Firefox/5.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have the same problem on a i865glc and a i875pbz . With hyperthreading off ,
or acpi
=off I can boot. It started with 2.6.39 Ihave tryed everything I know to fix
this to no avail .



