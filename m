Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3AGQoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 11:44:22 -0500
Received: from mga07.intel.com ([143.182.124.22]:48453 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752745Ab3AGQoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 11:44:20 -0500
Message-ID: <1357577053.8203.66.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] x86, efi: Allow slash in file path of initrd
From: Matt Fleming <matt.fleming@intel.com>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 07 Jan 2013 16:44:13 +0000
In-Reply-To: <1356003202-29516-1-git-send-email-jlee@suse.com>
References: <1356003202-29516-1-git-send-email-jlee@suse.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-20 at 19:33 +0800, Lee, Chun-Yi wrote:
> When initrd file didn't put at the same place with stub kernel, we
> need give the file path of initrd, but need use backslash to separate
> directory and file. It's not friendly to unix/linux user, and not so
> intuitive for bootloader forward paramters to efi stub kernel by
> chainloading.
> 
> This patch add support to handle_ramdisks for allow slash in file path
> of initrd, it convert slash to backlash when parsing path.
> 
> In additional, this patch also separates print code of efi_char16_t from
> efi_printk, and print out the path/filename of initrd when failed to open
> initrd file. It's good for debug and discover typo.
> 
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Matt Fleming <matt.fleming@intel.com> 
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  arch/x86/boot/compressed/eboot.c |   26 +++++++++++++++++++-------
>  1 files changed, 19 insertions(+), 7 deletions(-)

Thanks, I've queued this up. 


