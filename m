Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0JWKPk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 06:15:40 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60749 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab0JWKPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 06:15:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:content-type;
        b=SAHR+VlA68N2c0v8xfOt6WLTXbp8qBbARjVkNpjC168CRuGxt/og883Ty6120cn7Pn
         vlLwLELq1ARFFpzy1lS9zzJ6ksK/pZki8k2xc2wbwRRf592nh4u3lsIt3EsP8qD1yWqU
         t8tzq+2pLu+sSop44Rf8a1UfCgPIVOC9GzSv0=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sat, 23 Oct 2010 12:15:37 +0200
Message-ID: <AANLkTi=XW2dgbi5trX7Kvoj_1L_CveLk2E-FC37NDM7W@mail.gmail.com>
Subject: linux-2.6 GIT not accessible?
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Known problem?

$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
Cloning into linux-2.6...
fatal: The remote end hung up unexpectedly

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=summary
