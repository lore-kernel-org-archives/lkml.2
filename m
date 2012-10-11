Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab2JKN7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:59:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54468 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2JKN7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:59:11 -0400
Message-ID: <5076D0A8.3090707@canonical.com>
Date: Thu, 11 Oct 2012 21:59:04 +0800
From: Jeremy Kerr <jeremy.kerr@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20121003 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] efivarfs: efivarfs_fill_super() ensure we free our
 temporary name
References: <1349416496.810727.310563927016.1.gpush@pecola> <1349951541-20498-1-git-send-email-apw@canonical.com> <1349951541-20498-5-git-send-email-apw@canonical.com>
In-Reply-To: <1349951541-20498-5-git-send-email-apw@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

> d_alloc_name() copies the passed name to new storage, once complete we
> no longer need our name.

Acked-by: Jeremy Kerr <jeremy.kerr@canonical.com>

Cheers,


Jeremy

