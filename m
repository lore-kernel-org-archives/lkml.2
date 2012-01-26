Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab2AZR0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:26:11 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:7538 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753266Ab2AZR0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:26:10 -0500
X-IronPort-AV: E=Sophos;i="4.71,574,1320620400"; 
   d="scan'208";a="141576246"
Date: Thu, 26 Jan 2012 18:26:08 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org
Subject: Hardware locality (hwloc) v1.4 released
Message-ID: <20120126172608.GD4366@type.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Hardware Locality (hwloc) team is pleased to announce the release
of v1.4:

   http://www.open-mpi.org/projects/hwloc/

v1.4 is a major new release series.  It includes many new features and
changes over the v1.3.x series. The most noticeable improvement is the
ability to assemble the topologies of multiple nodes into a single
global one. See the Multi-node Topologies section in the documentation
for details.

Also please note that 64bits windows builds are now available for
download.

* Major features
  + Add "custom" interface and "assembler" tools to build multi-node
    topology. See the Multi-node Topologies section in the documentation
    for details.
* Interface improvements
  + Add symmetric_subtree object attribute to ease assumptions when consulting
    regular symmetric topologies.
  + Add a CPUModel and CPUType info attribute to Socket objects on Linux
    and Solaris.
  + Add hwloc_get_obj_index_inside_cpuset() to retrieve the "logical" index
    of an object within a subtree of the topology.
  + Add more NVIDIA CUDA helpers in cuda.h and cudart.h to find hwloc objects
    corresponding to CUDA devices.
* Discovery improvements
  + Add a group object above partial distance matrices to make sure
    the matrices are available in the final topology, except when this
    new object would contradict the existing hierarchy.
  + Grouping by distances now also works when loading from XML.
  + Fix some corner cases in object insertion, for instance when dealing
    with NUMA nodes without any CPU.
* Backends
  + Implement hwloc_get_area_membind() on Linux.
  + Honor I/O topology flags when importing from XML.
  + Further improve XML-related error checking and reporting.
  + Hide synthetic topology error messages unless HWLOC_SYNTHETIC_VERBOSE=1.
* Tools
  + Add synthetic exporting of symmetric topologies to lstopo.
  + lstopo --horiz and --vert can now be applied to some specific object types.
  + lstopo -v -p now displays distance matrices with physical indexes.
  + Add hwloc-distances utility to list distances.
* Documentation
  + Fix and/or document the behavior of most inline functions in hwloc/helper.h
    when the topology contains some I/O or Misc objects.
  + Backend documentation enhancements.
* Bug fixes
  + Fix missing last bit in hwloc_linux_get_thread_cpubind().
    Thanks to Carolina Gómez-Tostón Gutiérrez for reporting the issue.
  + Fix FreeBSD build without cpuid support.
  + Fix several Windows build issues.
  + Fix inline keyword definition in public headers.
  + Fix dependencies in the embedded library.
  + Improve visibility support detection. Thanks to Dave Love for providing
    the patch.
  + Remove references to internal symbols in the tools.
