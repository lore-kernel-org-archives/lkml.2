Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0EIPYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 11:24:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:40360 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0EIPYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 11:24:17 -0400
Date: Sun, 9 May 2010 08:21:26 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, davej@redhat.com
Subject: [PATCH v2  0/8] Fix performance issue with ondemand governor
Message-ID: <20100509082126.4a080d46@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Version 2 includes the acks/etc. Andrew: no changes from the
patches that are in -mm]



There have been various reports of the ondemand governor causing some
serious performance issues, one of the latest ones from Andrew.
There are several fundamental issues with ondemand (being worked on),
but the report from Andrew can be fixed relatively easily.

The fundamental issue is that ondemand will go to a (too) low CPU
frequency for workloads that alternatingly disk and CPU bound...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
