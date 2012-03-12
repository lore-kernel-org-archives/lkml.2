Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab2CLDAr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 23:00:47 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:60876 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab2CLDAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 23:00:42 -0400
Date: Sun, 11 Mar 2012 23:00:40 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: crash dump memory reservation regression
Message-ID: <65a23329-d843-4859-8b7b-430f12882492@zmail14.collab.prod.int.phx2.redhat.com>
In-Reply-To: <5535e246-b7c0-4f69-a27b-1abbadd42db0@zmail14.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.66.12.214]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 3661ca66a42e306aaf53246fb75aec1ea01be0f0
x86, memblock: Fix crashkernel allocation

introduced a regression that crashkernel=512M
according to bisecting will fail like this,

crashkernel reservation failed - No suitable area found.
The full dmesg can be found here.

http://people.redhat.com/qcai/dmesg.bad

CAI Qian
