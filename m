Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab0D0QUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 12:20:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51236 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795Ab0D0QUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 12:20:13 -0400
MIME-Version: 1.0
Message-ID: <8ea19b02-d4d8-4000-9842-fec7f5bcf90d@default>
Date: Tue, 27 Apr 2010 09:19:30 -0700 (PDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>, <akpm@linux-foundation.org>,
       Linux-Next <linux-next@vger.kernel.org>
Subject: linux-next: April 27 (mm/page-writeback)
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BD70E9D.0080:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_BLOCK is not enabled:

mm/page-writeback.c:707: error: dereferencing pointer to incomplete type
mm/page-writeback.c:708: error: dereferencing pointer to incomplete type

---
~Randy

