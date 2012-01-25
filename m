Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab2AYToh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 14:44:37 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53564 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2AYTof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 14:44:35 -0500
MIME-Version: 1.0
Date: Thu, 26 Jan 2012 01:14:34 +0530
Message-ID: <CA+h4rtFMtprNyW2GH601TY9gBY1JTWK+Wktka-RzD8MQogK+zQ@mail.gmail.com>
Subject: iproute2-2.6.38 + oif argument error
From: Ganesh Reddy K <ganeshreddyk@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Cc: Ganesh Reddy <ganeshreddyk@gmail.com>,
        ganeshreddy <ganeshreddy@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am trying to exercise 'ip rules'  command with some configuration on
 a PowerPC Processor. Version is iproute2-2.6.38


I tried "ip rule add oif eth1 table 100"
It  resulted with  error message "RTNETLINK answers: Invalid argument".

Can anybody tried this.

It is shown in the ip rule help all the possible options . Few of them
are iif, oif.    iif option is working . No issue observed.   oif
option is causing error.


Can you please share any patch fixes to proceed further ?

Thanks,
Ganesh
