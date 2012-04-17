Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab2DQOXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:23:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab2DQOXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:23:11 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Greg K H <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Document the EDAC MC userspace ABI
Date: Tue, 17 Apr 2012 11:22:58 -0300
Message-Id: <1334672580-12883-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334664371-10499-1-git-send-email-mchehab@redhat.com>
References: <1334664371-10499-1-git-send-email-mchehab@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the EDAC MC ABI description to the right place, and add the new
sysfs nodes there.

On this version, I decided to use the date where the API were firstly
added at git, and to remove my name as the contact for the legacy
stuff. I kept it there for the ABI bits I introduced.

Mauro Carvalho Chehab (2):
  edac: move documentation ABI to ABI/testing/sysfs-devices-edac
  Edac: Add ABI Documentation for the new device nodes

 Documentation/ABI/testing/sysfs-devices-edac |  140 ++++++++++++++++++++++++++
 Documentation/edac.txt                       |  112 ++-------------------
 2 files changed, 148 insertions(+), 104 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-edac

-- 
1.7.8

