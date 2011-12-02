Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab1LBEXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 23:23:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755377Ab1LBEXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 23:23:07 -0500
Message-ID: <4ED8529E.5070608@redhat.com>
Date: Fri, 02 Dec 2011 12:22:54 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Please add my tree to linux-next
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

As Andrew Morton suggested, please add my tree which contains all
of my patches for kmap_atomic() [1] to linux-next. Some of the
individual patches already got ACK from subsystem maintainers.
The tree is hosted on github:

     git://github.com/congwang/linux.git #kmap_atomic

I already rebased it to today's Linus tree.

Please let me know if I need to do anything else.

Thanks!

1. http://lkml.org/lkml/2011/11/27/2
