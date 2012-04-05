Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab2DEVhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 17:37:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46162 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab2DEVhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 17:37:02 -0400
Date: Thu, 5 Apr 2012 14:37:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Masanari Iida <standby24x7@gmail.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Documentation: mm: Add compact_node on
 Documentation/sysctl/vm.txt
In-Reply-To: <1333644489-31466-1-git-send-email-standby24x7@gmail.com>
Message-ID: <alpine.DEB.2.00.1204051434491.17852@chino.kir.corp.google.com>
References: <1333644489-31466-1-git-send-email-standby24x7@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2012, Masanari Iida wrote:

> The Documentation/sysctl/vm.txt does include "compact_memory",
> but it doesn't include "compact_node".
> 

That's because /proc/sys/vm/compact_node doesn't exist.

The per-node compaction trigger is at 
/sys/device/system/node/nodeX/compact which is appropriately documented in 
Documentation/ABI/testing/sysfs-devices-node.
