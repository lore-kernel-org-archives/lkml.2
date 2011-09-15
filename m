Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab1IOH63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 03:58:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44017 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab1IOH62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 03:58:28 -0400
Date: Thu, 15 Sep 2011 00:58:48 -0700
From: Andrew Morton <akpm00@gmail.com>
To: Anton Blanchard <anton@samba.org>
Cc: gregkh@suse.de, nfont@austin.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memory hotplug: Refuse to add unaligned memory regions
Message-Id: <20110915005848.59e6fb36.akpm@linux-foundation.org>
In-Reply-To: <20110915062615.782bc4df@kryten>
References: <20110915062615.782bc4df@kryten>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Sep 2011 06:26:15 +1000 Anton Blanchard <anton@samba.org> wrote:

> 
> The sysfs memory probe interface allows unaligned regions
> to be added:
> 
> # echo 0xffffff > /sys/devices/system/memory/probe
> 
> # cat /proc/iomem 
> 00ffffff-01fffffe : System RAM
> 01ffffff-02fffffe : System RAM
> 02ffffff-03fffffe : System RAM
> 03ffffff-04fffffe : System RAM
> 04ffffff-05fffffe : System RAM

Then don't do that?

