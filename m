Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428Ab0DKJRM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 05:17:12 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:51149 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab0DKJRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 05:17:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=kMaKvjVu4GR2GsL72km7r1zBOo87CZr2dgBOVmuxAlPqh9BoWP/Z6UxGVlKmH93iF+
         OpUEFmV1nnX7foAVsMTUEO5EhXsmEkP91MyW6cPM/XvDVUcSclKf7o4zl41NufXy4+Jg
         8qegteyjdmJKD6LR7rdt8m8Ju5I8qzA0kvyhk=
MIME-Version: 1.0
Date: Sun, 11 Apr 2010 02:17:09 -0700
X-Google-Sender-Auth: 55575cde4714c6c5
Message-ID: <r2v86802c441004110217u15591f95ydd1e8e1466a36dc2@mail.gmail.com>
Subject: ssh server etc doesn't work anymore with net-2.6
From: Yinghai Lu <yinghai@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

caused by:

commit 2626419ad5be1a054d350786b684b41d23de1538
Author: David S. Miller <davem@davemloft.net>
Date:   Thu Apr 8 11:32:30 2010 -0700

    tcp: Set CHECKSUM_UNNECESSARY in tcp_init_nondata_skb

it will make sshd server, telnet server and vnc server doesn't respond
connecting request anymore.

YH
