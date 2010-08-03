Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab0HCHMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 03:12:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33557 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab0HCHMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 03:12:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:references:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=cgUM+knuufw7epZoecNsBuT5jrkJzFnYMgtnIYOT+yZz4vP7YobmBvNXGbFvUw55qM
         Vg26TFj5dJJOusjdRCw1e4zK1BLUHgHQjL/7Su+YF/xU2BhmqdTkAU5DeMY0jp2g6+Yp
         E1t1jmok+KN4SCmUGb7PtPCBUodeN4pIMkeoM=
Date: Tue, 3 Aug 2010 15:11:59 +0800
From: "hacklu" <embedway.linux@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
References: <201008031037022524247@gmail.com>
Subject: how about KBUILD_MODNAME
Message-ID: <201008031511572638256@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I don't understand the macro KBUILD_MODNAME .
when I compile a  driver program. It returns me "linux/pci.h:655: error: 'KBUILD_MODNAME' undeclared (first use in this function) "

In the makefile I had used the "-D" options




thanks a lot

2010-08-03 



hacklu 

