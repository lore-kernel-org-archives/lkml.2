Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab2JBSMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 14:12:35 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57518 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab2JBSMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 14:12:33 -0400
Message-ID: <506B2E63.5090900@linux.vnet.ibm.com>
Date: Tue, 02 Oct 2012 13:11:47 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: devicetree-discuss@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 0/5] Move some OF functionality from pseries to generic OF
 code
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100218-2876-0000-0000-000000AB56F9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches moves some OF code that has been living
in the pseries tree over to the generic OF code base. The
functionality being migrated over is something that, I believe,
should live in the generic code base. The specific functionality
being migrated to generic OF code is;

o Updating the device tree in /proc when adding/removing a node.
o Adding a notification chain for adding/removing nodes and
  properties of the device tree.
o Re-naming the base OF code prom_* routines to of_* to better go
  with the naming used for OF code.

-Nathan 

