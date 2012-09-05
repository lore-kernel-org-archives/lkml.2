Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759843Ab2IEWut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 18:50:49 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50410 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759829Ab2IEWus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 18:50:48 -0400
MIME-Version: 1.0
Date: Wed, 5 Sep 2012 19:50:47 -0300
Message-ID: <CALF0-+ViKZe=QoNYqz_vyoQc5kH1EJ5K5M=HfGdvOFjnWY1BbA@mail.gmail.com>
Subject: [PATCH 0/5] mm, slob: Tracing accuracy improvement
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        Glauber Costa <glommer@parallels.com>, Tim Bird <tim.bird@am.sony.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This small patchset improves mm tracing accuracy, particularly on the
slob allocator.
Feedback, comments, suggestions are very welcome.

This work is part of CELF Workgroup Project:
"Kernel_dynamic_memory_allocation_tracking_and_reduction" [1]

Ezequiel Garcia (5):
 mm, slob: Trace allocation failures consistently
 mm, slob: Use only 'ret' variable for both slob object and returned pointer
 mm, util: Do strndup_user allocation directly, instead of through memdup_user
 mm, slob: Add support for kmalloc_track_caller()
 mm, slab: Remove silly function slab_buffer_size()

 include/linux/slab.h |    6 +++-
 mm/slab.c            |   12 +--------
 mm/slob.c            |   62 +++++++++++++++++++++++++++++++++++--------------
 mm/util.c            |   15 +++++++++--
 4 files changed, 62 insertions(+), 33 deletions(-)

Thanks!
Ezequiel.

[1] http://elinux.org/Kernel_dynamic_memory_allocation_tracking_and_reduction
