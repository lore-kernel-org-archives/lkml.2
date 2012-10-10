Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab2JJKNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 06:13:16 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52649 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab2JJKNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 06:13:12 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <linux-kernel@vger.kernel.org>, <e1000-devel@lists.sf.net>
Cc: <support@Supermicro.com>, <ap@solarrain.com>
References: <003901cda66b$836a5db0$8a3f1910$@lucidpixels.com>
In-Reply-To: <003901cda66b$836a5db0$8a3f1910$@lucidpixels.com>
Subject: RE: X9SCM-F/82574L/e1000e lag / high latency (e1000e/Intel bug)
Date: Wed, 10 Oct 2012 06:13:09 -0400
Message-ID: <001201cda6cf$d9de5480$8d9afd80$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIdryc2JFTBlaO/4vE9Qu1npX97rpcSQSzg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Justin Piszcz [mailto:jpiszcz@lucidpixels.com] 
Sent: Tuesday, October 09, 2012 6:15 PM
To: linux-kernel@vger.kernel.org; e1000-devel@lists.sf.net
Cc: support@Supermicro.com; ap@solarrain.com
Subject: X9SCM-F/82574L/e1000e lag / high latency (e1000e/Intel bug)

If you have > 16GB do not upgrade to 2.0b, I am writing up a page on this
and will post it shortly, the board will show 32GB with 2.0b but when it
tries to address it, the machine reboots.  Stick with 2.0a for now, I will
call Supermicro later, will post a page on all of these issues in a bit.

