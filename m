Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab1FLDeS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 23:34:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56451 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1FLDeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 23:34:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=HKv7sinqoDkwzBnKxPIVFggvXyNTmbUrWJhLwVAKY2/WgKiJRSCOiX0uzI7LRMAr0n
         Y/3dclp91wKmgHTnOaG3PKjjbLkmek/7xUwKgYaiZahQdnYGkm5lXUQDDEXItXCeYruR
         imBL4IJzZOqRLxToeEQcXNtcLlsYe+10flAEM=
Date: Sun, 12 Jun 2011 11:33:48 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, linux-kernel@zh-kernel.org,
        synmyth@gmail.com, zhangyangjing@gmail.com, wangxiaochen0@gmail.com,
        yaxinsn@163.com
Subject: [PATCH v3 0/2]Documentation/zh_CN: Fix messy code files
Message-ID: <20110612033343.GA4321@gmail.com>
Mail-Followup-To: greg@kroah.com, linux-kernel@vger.kernel.org,
	linux-kernel@zh-kernel.org, synmyth@gmail.com,
	zhangyangjing@gmail.com, wangxiaochen0@gmail.com, yaxinsn@163.com
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harry Wei <harryxiyou@gmail.com>

This is v3 patches for fixing the messy code files,
Documentation/zh_CN/email-clients.txt and
Documentation/zh_CN/SubmitChecklist.

v3's new figures.
Combine the remove and add back operations to one single patch.
So now we have only two patches for fixing this problem.

Harry Wei (2)
Documentation/zh_CN: Fix messy code file email-clients.txt
Documentation/zh_CN: Fix messy code file SubmitChecklist

Thanks
Harry Wei
