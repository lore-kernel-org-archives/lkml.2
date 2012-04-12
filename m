Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762958Ab2DLWpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:45:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47020 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790Ab2DLWpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:45:32 -0400
Date: Thu, 12 Apr 2012 15:45:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86, microcode: Ensure that module is only loaded for
Message-ID: <20120412224527.GB22089@kroah.com>
References: <20120411163849.GE4794@alberich.amd.com>
 <20120411200601.GC12288@kroah.com>
 <20120411201053.GF18114@aftab>
 <20120412162351.GJ24549@aftab>
 <20120412163422.GM24549@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412163422.GM24549@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 06:34:22PM +0200, Borislav Petkov wrote:
> From: Andreas Herrmann <andreas.herrmann3@amd.com>
> Date: Thu, 12 Apr 2012 16:51:57 +0200
> Subject: [PATCH 2/2] x86, microcode: Ensure that module is only loaded for supported AMD CPUs
> 
> Exit early when there's no support for a particular CPU family. Also,
> fixup the "no support for this CPU vendor" to be issued only when the
> driver is attempted to be loaded on an unsupported vendor.
> 
> Cc: stable@vger.kernel.org
> Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
> Cc: Borislav Petkov <borislav.petkov@amd.com>
> [Boris: added a commit msg because Andreas is lazy]
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
