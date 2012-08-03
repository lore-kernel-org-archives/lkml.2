Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab2HCOwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:52:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50462 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab2HCOwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:52:39 -0400
Message-ID: <501BE5B2.5040901@pobox.com>
Date: Fri, 03 Aug 2012 10:52:34 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@amd.com>
CC: Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Oliver Neukum <oneukum@suse.de>, Jeff Wu <jeff.wu@amd.com>,
        Lin Ming <minggr@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
Subject: Re: [PATCH v4 4/7] scsi: sr: block events when runtime suspended
References: <1343379650-2867-1-git-send-email-aaron.lu@amd.com> <1343379650-2867-5-git-send-email-aaron.lu@amd.com> <501B9EE7.1080000@amd.com>
In-Reply-To: <501B9EE7.1080000@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 05:50 AM, Aaron Lu wrote:
> Hello,
>
> Not sure if I should use EXPORT_SYMBOL or EXPORT_SYMBOL_GPL, any
> comments?

Typically you follow the pattern of similar exports in the file (or in 
the API, if no others are in the file).

	Jeff





