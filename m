Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712Ab2JKNxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:53:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54437 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab2JKNxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:53:18 -0400
Message-ID: <5076CF46.4040204@canonical.com>
Date: Thu, 11 Oct 2012 21:53:10 +0800
From: Jeremy Kerr <jeremy.kerr@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20121003 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] efivarfs: efivarfs_file_read ensure we free data
 in error paths
References: <1349416496.810727.310563927016.1.gpush@pecola> <1349951541-20498-1-git-send-email-apw@canonical.com> <1349951541-20498-2-git-send-email-apw@canonical.com>
In-Reply-To: <1349951541-20498-2-git-send-email-apw@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

 > Signed-off-by: Andy Whitcroft <apw@canonical.com>
 > ---
 >   drivers/firmware/efivars.c |    6 +++---
 >   1 file changed, 3 insertions(+), 3 deletions(-)
 >

Looks good to me.

Acked-by: Jeremy Kerr <jeremy.kerr@canonical.com>

Cheers,


Jeremy
