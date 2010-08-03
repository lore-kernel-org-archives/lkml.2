Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821Ab0HCW2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 18:28:54 -0400
Received: from phil.doycomm.com ([66.219.128.249]:51516 "EHLO phil.doycomm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997Ab0HCW2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 18:28:53 -0400
Subject: Re: 2.6.35 hangs on early boot in KVM
From: Donald Parsons <dparsons@brightdsl.net>
To: Avi Kivity <avi@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 18:28:33 -0400
Message-ID: <1280874513.26472.18.camel@falcon.homelinux.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wonder if this thread is a similar problem.  If so, does setting
CONFIG_SATA_AHCI=y cause booting?

http://lkml.indiana.edu/hypermail/linux/kernel/1008.0/00254.html

Don

