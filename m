Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2IFOXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:23:08 -0400
Received: from smtp.infotech.no ([82.134.31.41]:33544 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497Ab2IFOXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:23:06 -0400
Message-ID: <5048B1C2.1060909@interlog.com>
Date: Thu, 06 Sep 2012 10:22:58 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Martin Pitt <martin.pitt@ubuntu.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [SCSI] scsi_debug: Add "removable" parameter
References: <20120906100307.GC2864@piware.de> <20120906100433.GD2864@piware.de>
In-Reply-To: <20120906100433.GD2864@piware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-09-06 06:04 AM, Martin Pitt wrote:
> Add "removable" module parameter to set the "removable" attribute of any
> subsequently created debug block device. It is a writable driver option, so
> that you can switch between removable and "fixed" media block devices in
> between the add_host calls.
>
> This is useful for being able to test the different behaviour/required
> privileges in e. g. the udisks test suite.
>
> Signed-off-by: Martin Pitt <martin.pitt@ubuntu.com>
> Acked-By: David Zeuthen <zeuthen@gmail.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

