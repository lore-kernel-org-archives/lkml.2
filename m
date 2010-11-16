Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933969Ab0KPHa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 02:30:56 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65208 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab0KPHay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 02:30:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ElWKUw8+Miq6hXJg6HIExU2i0UPFTTxLlJuuvNZMeUZ8KNgBBwIx24PieT8awWblfz
         zmpsDLuixW01+46ZjhAHgZKDVpaoEe0YpizwLdxPTOw/bq63Kr35oDlxKQuRx4HECySQ
         Ejiqj+eWIdJW06F8AbygWt8xqL8A/NcEho/hc=
MIME-Version: 1.0
Date: Tue, 16 Nov 2010 09:30:53 +0200
Message-ID: <AANLkTinLKibXfnN2XSVE2P_x3EJancRNdi3B4YBxvL=j@mail.gmail.com>
Subject: Build failure 2.6.37-rc2
From: Anca Emanuel <anca.emanuel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Building modules, stage 2.
  MODPOST 2794 modules
FATAL: arch/x86/kernel/msr.o has no symtab?
make[2]: *** [__modpost] Error 1
make[1]: *** [modules] Error 2
make[1]: Leaving directory `/home/emi/linux-2.6'
make: *** [debian/stamp/build/kernel] Error 2
