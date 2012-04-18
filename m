Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab2DRWz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 18:55:56 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:58410 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab2DRWzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 18:55:51 -0400
Date: Wed, 18 Apr 2012 15:55:47 -0700
From: Greg K H <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Edac: Add ABI Documentation for the new device nodes
Message-ID: <20120418225547.GB27508@kroah.com>
References: <1334672580-12883-1-git-send-email-mchehab@redhat.com>
 <1334672580-12883-3-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334672580-12883-3-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 11:23:00AM -0300, Mauro Carvalho Chehab wrote:
> The EDAC ABI were extended to add support for per-DIMM or per-rank
> information and silkscreen labels. Properly document them.
> 
> Most of the comments there came from edac.txt descriptions of the
> fields that are part of the legacy csrowX ABI (e. g.
> /sys/devices/system/edac/mc/mc*/csrow*/*).
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

