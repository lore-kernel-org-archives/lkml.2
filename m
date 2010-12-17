Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab0LQBFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 20:05:20 -0500
Received: from iona.labri.fr ([147.210.8.143]:59996 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755762Ab0LQBFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 20:05:14 -0500
X-Greylist: delayed 1740 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Dec 2010 20:05:14 EST
Date: Fri, 17 Dec 2010 01:31:28 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org
Subject: Hardware locality (hwloc) v1.0.3 released
Message-ID: <20101217003128.GE15302@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just in time for the holidays, the Hardware Locality (hwloc) team is pleased to announce the release of v1.0.3:

    http://www.open-mpi.org/projects/hwloc/ 

v1.0.3 is a minor bug fix release which addresses all remaining known bugs in the v1.0 series.  

We expect that v1.0.3 will be the last release of this series.

hwloc provides command line tools and a C API to obtain the hierarchical map of key computing elements, such as: NUMA memory nodes, shared caches, processor sockets, processor cores, and processor "threads". hwloc also gathers various attributes such as cache and memory information, and is portable across a variety of different operating systems and platforms. 

The following is a summary of the changes since v1.0.2: 

* Fix support for Linux cpuset when emulated by a cgroup mount point.
* Remove unneeded runtime dependency on libibverbs.so in the library and
  all utils programs.
* Fix hwloc_cpuset_to_linux_libnuma_ulongs in case of non-linear OS-indexes
  for NUMA nodes.
* lstopo now displays physical/OS indexes by default in graphical mode
  (use -l to switch back to logical indexes). The textual output still uses
  logical by default (use -p to switch to physical indexes).
