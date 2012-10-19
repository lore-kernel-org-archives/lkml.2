Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984Ab2JSRjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:39:41 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:35984 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab2JSRjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:39:39 -0400
Date: Fri, 19 Oct 2012 10:39:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: joseph.salisbury@canonical.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        perex@perex.cz, tiwai@suse.de, david.henningsson@canonical.com,
        alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] ALSA: hda - add quirk for Thinkpad T430
Message-ID: <20121019173935.GA2619@kroah.com>
References: <cover.1350570761.git.joseph.salisbury@canonical.com>
 <fe78ea8daff3d5a41b6e1c78fb527894da6ad71e.1350570761.git.joseph.salisbury@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe78ea8daff3d5a41b6e1c78fb527894da6ad71e.1350570761.git.joseph.salisbury@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 10:32:30AM -0400, joseph.salisbury@canonical.com wrote:
> From: Joseph Salisbury <joseph.salisbury@canonical.com>
> 
> 
> Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
> ---
>  sound/pci/hda/patch_realtek.c |    1 +
>  1 file changed, 1 insertion(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
