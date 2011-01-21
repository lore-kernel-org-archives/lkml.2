Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab1AUE6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 23:58:10 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35584 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1AUE6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 23:58:07 -0500
Date: Fri, 21 Jan 2011 04:57:54 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ali Gholami Rudi <aliqrudi@gmail.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-acpi@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: [Intel-gfx] [PATCH 2/5] i915: Add native backlight control
Message-ID: <20110121045754.GA9897@srcf.ucam.org>
References: <1295033065-13450-1-git-send-email-mjg@redhat.com> <1295033065-13450-2-git-send-email-mjg@redhat.com> <20112101000015@lilem.mirepesht> <20112101004346@lilem.mirepesht> <20110120151349.49cf3ebb.akpm@linux-foundation.org> <20110121004359.GA6422@srcf.ucam.org> <20110120170337.94d83333.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120170337.94d83333.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 05:03:37PM -0800, Andrew Morton wrote:
> I updated the new drivers/video/backlight/adp5520_bl.c, but there's a
> decent chance that unconverted drivers will sneak in.  I trust they
> will still work OK?

They should fire a warning on registration but otherwise work. I'll send 
fixup patches for any I see.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
