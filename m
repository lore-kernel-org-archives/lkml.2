Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194Ab0HLOQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 10:16:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46039 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759974Ab0HLOQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 10:16:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=N1sgrzX0jfqjIazg7P3UIUO+IoS+7TRwqm05ZCabIFVn84un/Cmqe4pIlV3xTiV+jd
         IVq+MbISZbd0MkfLV7gBMJ9LYbsDnXOZdAyIFSG4DSSICuA5gt8rscCei2Z0NTksuXQ8
         VNEhyPBTDRl/lHrsHEsPNf13sBtfxFaTdnhqQ=
Date: Thu, 12 Aug 2010 16:16:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, Joern Engel <joern@logfs.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Last ioctl bkl pushdown in the LogFS tree, but no pull request?
Message-ID: <20100812141629.GA5369@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joern,

The Logfs tree contains the last ioctl bkl pushdown that is not yet upstream.

git://git.kernel.org/pub/scm/linux/kernel/git/joern/logfs.git
	ddbb5dd99c40a695d5d75645b5a18bef394acb16
	"logfs: kill BKL"

This patch seems to have missed the 2.6.35 merge window already. Do you
plan to make a pull request for 2.6.36 that includes this patch?

In fact the merge window is almost closed now. Since this is delaying
the final removal of struct file_operations:ioctl, the only solution
for us would be to cherry pick this patch from your tree. But
really I would hate to do that behind your back.

Please tell us what are your plans.

Thanks.

