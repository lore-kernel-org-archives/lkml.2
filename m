Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464Ab0ERSKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:10:33 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48418 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328Ab0ERSKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:10:31 -0400
Date: Tue, 18 May 2010 11:10:01 -0700
From: Vernon Mauery <vernux@us.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 0/3] i7core_edac updates
Message-ID: <20100518181001.GX6511@lucy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three patches for i7core_edac

In developing support for the Westmere processor with i7core_edac, I 
also found two bugs.  Both are basically typos that were introduced in 
earlier updates.  The third patch adds a table that keeps track of the 
tables for pci ids that the i7core_edac driver supports.  This makes it 
more convenient to add more devices later as Intel adds more ids to the 
list of supported devices.

These three patches apply to linux-next.

--Vernon
