Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab1C2Ooj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:44:39 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34506 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1C2Ooi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sTBDo9MvOnORHshiHG1wGuG35VzCby7Ww3kSAmjJJiwmXqX0KJerJUK9lvlXCF+nga
         ur/3IxpUoHr806MstoddQ88UIp6T5vnoD8e2B6Q2TlatLa05+E9Ocby/ou4Znl8pOyvI
         SISyf/ioNaDTYDjGydy36JVU3NuZQKUVaakH4=
Subject: Re: GEM-related desktop sluggishness due to linear-time
 arch_get_unmapped_area_topdown()
From: r6144 <rainy6144@gmail.com>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Lucas Stach <dev@lynxeye.de>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
In-Reply-To: <AANLkTikMJszEyv8-SMMjD-MeykSwmsKf=gmezcMgySoP@mail.gmail.com>
References: <1301310995.5615.92.camel@wangqingchuan>
	 <1301336010.2217.20.camel@workstation>
	 <AANLkTikMJszEyv8-SMMjD-MeykSwmsKf=gmezcMgySoP@mail.gmail.com>
Content-Type: text/plain; charset="GB2312"
Date: Tue, 29 Mar 2011 22:44:24 +0800
Message-ID: <1301409864.5615.98.camel@wangqingchuan>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2011-03-29二的 10:22 -0400，Jerome Glisse写道：

> Killer solution would be to have no mapping and a decent
> upload/download ioctl that can take userpage.

Doesn't this sound like GEM's read/write interface implemented by e.g.
the i915 driver?  But if I understand correctly, a mmap-like interface
should still be necessary if we want to implement e.g. glMapBuffer()
without extra copying.

r6144

