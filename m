Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab0D0QPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 12:15:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47380 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0D0QPn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 12:15:43 -0400
MIME-Version: 1.0
Message-ID: <80edf231-ef31-4f21-ab1b-1a21fda35809@default>
Date: Tue, 27 Apr 2010 09:13:16 -0700 (PDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Cc: Peter Jones <pjones@redhat.com>, Konrad Rzeszutek Wilk <konrad@kernel.org>,
       <linux-next@vger.kernel.org>
Subject: linux-next: April 27 (iscsi_ibft)
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BD70D77.0018:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when CONFIG_ACPI is not enabled:

drivers/firmware/iscsi_ibft_find.c:112: error: dereferencing pointer to incomplete type
drivers/firmware/iscsi_ibft_find.c:112: error: dereferencing pointer to incomplete type
drivers/firmware/iscsi_ibft_find.c:112: warning: type defaults to 'int' in declaration of 'type name'
drivers/firmware/iscsi_ibft_find.c:112: error: dereferencing pointer to incomplete type
drivers/firmware/iscsi_ibft_find.c:112: warning: type defaults to 'int' in declaration of 'type name'

---
~Randy

