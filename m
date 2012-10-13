Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab2JME0b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 00:26:31 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48749 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab2JME0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 00:26:30 -0400
MIME-Version: 1.0
In-Reply-To: <2456603.OlK4shzgJ4@wuerfel>
References: <415E76CC-A53D-4643-88AB-3D7D7DC56F98@dubeyko.com>
	<alpine.LFD.2.00.1210091020390.11244@dhcp-1-104.brq.redhat.com>
	<1349865374.6072.78.camel@shinybook.infradead.org>
	<2456603.OlK4shzgJ4@wuerfel>
Date: Sat, 13 Oct 2012 13:26:28 +0900
Message-ID: <CAKYAXd99LRV0VqpGRKxBnDd7MORkLJScZ7M5k14sZmxz-uS-Gw@mail.gmail.com>
Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file system
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>, David Woodhouse <dwmw2@infradead.org>,
        =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>,
        Vyacheslav Dubeyko <slava@dubeyko.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Jaegeuk Kim <jaegeuk.kim@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        tytso@mit.edu, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there high possibility that the storage device can be rapidly
worn-out by cleaning process ? e.g. severe fragmentation situation by
creating and removing small files.

And you told us only advantages of f2fs. Would you tell us the disadvantages ?

Thanks.
