Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab2AMSXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:23:13 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:46944 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab2AMSXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:23:12 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: sjenning@linux.vnet.ibm.com, ngupta@vflare.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fixes for zcache for 3.3 [v1]
Date: Fri, 13 Jan 2012 09:44:33 -0500
Message-Id: <1326465874-11791-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F10768D.0017,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

I was thinking to send this along to Greg for 3.3-rc1 as a bug-fix.
I think we had an informal Ack on it, but just in case posting this
bug-fix here.


