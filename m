Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740Ab2JKOKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 10:10:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54540 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab2JKOKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 10:10:34 -0400
Message-ID: <5076D354.4040803@canonical.com>
Date: Thu, 11 Oct 2012 22:10:28 +0800
From: Jeremy Kerr <jeremy.kerr@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20121003 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] efivarfs: efivarfs_fill_super() fix inode reference
 counts
References: <1349416496.810727.310563927016.1.gpush@pecola> <1349951541-20498-1-git-send-email-apw@canonical.com> <1349951541-20498-4-git-send-email-apw@canonical.com>
In-Reply-To: <1349951541-20498-4-git-send-email-apw@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

> When d_make_root() fails it will automatically drop the reference
> on the root inode.  We should not be doing so as well.

Looks good:

Acked-by: Jeremy Kerr <jeremy.kerr@canonical.com>

Cheers,


Jeremy

