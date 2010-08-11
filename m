Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab0HKWF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 18:05:28 -0400
Received: from caiajhbdcbef.dreamhost.com ([208.97.132.145]:41285 "EHLO
	homiemail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754098Ab0HKWF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 18:05:26 -0400
Subject: Outdated sysfs.txt document?
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: mochel@osdl.org, mamurph@cs.clemson.edu
Cc: LKML <linux-kernel@vger.kernel.org>, linux-doc <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 18:05:21 -0400
Message-ID: <1281564321.1934.5.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have been going through Documentation/filesystems/sysfs.txt, and
noticed what I believe to be either outdated or incomplete:

The "Top Level Directory Layout" mentions
block/
bus/
class/
dev/
devices/
firmware/
net/
fs/

We seem to be missing kernel, power, hypervisor, module, etc. 

dave@cowboy:~$ ls /sys/
block  class  devices   fs          kernel  power
bus    dev    firmware  hypervisor  module

I am preparing a patch to complete this, but could someone confirm first
that this is actually what is meant.

Thanks,
Davidlohr

