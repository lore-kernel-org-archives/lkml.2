Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532Ab1FKCiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 22:38:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55970 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758510Ab1FKCiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 22:38:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=ESHc2J9+4XPCreX8Zo29Oulwrne1LEMb8mblOcSw/XK3ZOD0DpWVbnooVXPjPTOmzG
         hwttWc1pg3sV/upDqVxU75lXynu90e81pml6ItUmoEwjeRrzXnlSnYD3GuJyw9tNLr/t
         b2YrV9Punog9NW7z0To2du6+WaRhXCcwv/y48=
Date: Sat, 11 Jun 2011 10:37:52 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, synmyth@gmail.com, zhangyangjing@gmail.com,
        wangxiaochen0@gmail.com, linux-kernel@zh-kernel.org, yaxinsn@163.com
Subject: [PATCH v2 0/4]Documentation/zh_CN: Remove messy code
 documentations and rebuild new documentations
Message-ID: <20110611023749.GA2101@gmail.com>
Mail-Followup-To: greg@kroah.com, linux-kernel@vger.kernel.org,
	synmyth@gmail.com, zhangyangjing@gmail.com, wangxiaochen0@gmail.com,
	linux-kernel@zh-kernel.org, yaxinsn@163.com
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harry Wei <harryxiyou@gmail.com>

There are two messy code documentations in our
Documentation/zh_CN/ directory. They are
Documentation/zh_CN/email-clients.txt &
Documentation/zh_CN/SubmitChecklist.
The following patches can fix them.

Harry Wei (4)
Documentation/zh_CN: remove messy code file email-clients.txt
Documentation/zh_CN: remove messy code file SubmitChecklist
Documentation/zh_CN: add new file email-clients.txt
Documentation/zh_CN: add new file SubmitChecklist

Thanks
Harry Wei
