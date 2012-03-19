Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab2CSCfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 22:35:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49751 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab2CSCff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 22:35:35 -0400
Date: Sun, 18 Mar 2012 19:35:31 -0700
From: Gerard Snitselaar <dev@snitselaar.org>
To: xen-devel@lists.xensource.com
Cc: konrad.wilk@oracle.com, jeremy@goop.org, linux-kernel@vger.kernel.org
Subject: section mismatch in vcpu_hotplug() in linux-next
Message-ID: <20120319023531.GA22956@perelman.Home>
Reply-To: Gerard Snitselaar <dev@snitselaar.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I get the following section mismatch when building linux-next:

WARNING: vmlinux.o(.text+0xc93f32): Section mismatch in reference from the function vcpu_hotplug() to the function .cpuinit.text:cpu_up()
The function vcpu_hotplug() references
the function __cpuinit cpu_up().
This is often because vcpu_hotplug lacks a __cpuinit 
annotation or the annotation of cpu_up is wrong.

Is this a benign warning?
 
