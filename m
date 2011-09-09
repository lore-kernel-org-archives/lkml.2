Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313Ab1IIK1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 06:27:52 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:55874 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758674Ab1IIK1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 06:27:37 -0400
Message-Id: <20110909102659.320220628@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Sep 2011 12:26:59 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: vgoyal@redhat.com
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 0/2] kdump: Initialize vmcoreinfo note at startup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

Another patch that we would like to have upstream is the vmcoreinfo
note intitialization. This is independent from the s390 kdump port.
We need that for our traditional stand-alone and hypervisor dump
tools. You already have agreed that the patch looks ok:
https://lkml.org/lkml/2011/7/20/296

So could we get an ACK from you for the patch?

[1] kdump: Initialize vmcoreinfo note at startup
[2] s390: Export vmcoreinfo note

Thanks!

Michael
