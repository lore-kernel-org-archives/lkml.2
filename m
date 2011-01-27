Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1A0Wo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 17:44:56 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49005 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab1A0Woz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 17:44:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rENpCTir97Qf0zXW0jQ3eODvPx2z/BtGOXm5fQgLi03+ZFnF1LbBmr9gQ/OztvxelV
         iceO1RvV5F/RTA5YhrBHy/SE8SGvvZSps85nrJZLEXsPiPQgD01G54h5/CEqqTB/SMmw
         ASwzqY7QkF35lP0U0ZpO7wbKUM5+O2ob68JEQ=
MIME-Version: 1.0
In-Reply-To: <1294774649.1337.7.camel@d941e-10>
References: <1294774649.1337.7.camel@d941e-10>
Date: Thu, 27 Jan 2011 23:44:54 +0100
Message-ID: <AANLkTi=BXgDKk3c97XJ+WiCiiPjiYL3dZPWiGg=i3KXp@mail.gmail.com>
Subject: Re: [PATCH] tpm_tis: Use timeouts returned from TPM
From: Guillaume Chazarain <guichaz@gmail.com>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srajiv@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 8:37 PM, Stefan Berger
<stefanb@linux.vnet.ibm.com> wrote:
> The current TPM TIS driver in git discards the timeout values returned
> from the TPM.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=c4ff4b829ef9e6353c0b133b7adb564a68054979
broke the TPM for me on a thinkpad T410. When using the TPM, dmesg
complains:

[   65.728310] tpm_tis 00:0b: Operation Timed out
[   67.651450] tpm_tis 00:0b: Operation Timed out
[   69.669421] tpm_tis 00:0b: Operation Timed out

This patch fixes it, so consider it:

Tested-by: Guillaume Chazarain <guichaz@gmail.com>

Thanks!

-- 
Guillaume
