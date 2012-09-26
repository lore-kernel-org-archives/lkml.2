Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311Ab2IZCFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 22:05:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51093 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2IZCFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 22:05:30 -0400
Date: Tue, 25 Sep 2012 19:05:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Felix Kaechele <felix@fetzig.org>
Cc: tiwai@suse.de, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ALSA: hda - Add inverted internal mic quirk for Lenovo
 IdeaPad U310
Message-ID: <20120926020526.GA21782@kroah.com>
References: <1348615244-26952-1-git-send-email-felix@fetzig.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348615244-26952-1-git-send-email-felix@fetzig.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 01:20:44AM +0200, Felix Kaechele wrote:
> The Lenovo IdeaPad U310 has an internal mic where the right channel
> is phase inverted.
> 
> Signed-off-by: Felix Kaechele <felix@fetzig.org>
> ---
>  sound/pci/hda/patch_conexant.c | 1 +
>  1 file changed, 1 insertion(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
