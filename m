Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759028Ab2EJKxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:53:23 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37871 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754358Ab2EJKxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:53:21 -0400
Message-ID: <4FAB9DFC.4040403@mvista.com>
Date: Thu, 10 May 2012 14:52:44 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Thang Q. Nguyen" <tqnguyen@apm.com>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 3/5] sata_dwc: Add support ATAPI transfer
References: <1336623449-7697-1-git-send-email-tqnguyen@apm.com> <4FAB8F51.3010004@mvista.com> <CAKrQpSvqz-+w=Rvq_jtGwkEue0Tf6rh9Z5c9j4edbgeuWeMCVQ@mail.gmail.com>
In-Reply-To: <CAKrQpSvqz-+w=Rvq_jtGwkEue0Tf6rh9Z5c9j4edbgeuWeMCVQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10-05-2012 14:12, Thang Q. Nguyen wrote:

> Thanks for quick response,
> I do not mean user use fdisk command on CD/DVD. However, whenever using 'fdisk
> -l' command, the system will access each first sector on each SCSI device
> (including CD/DVD on it) and the DMA transfer on blank CD/DVD will not return
> any data.

    Shouldn't the drive return error status in this case?

> The timeout is detected and error handler will be called.

    But user may also run 'hdparm -t' or even 'dd' with offset on a drive. 
Have you tried your workaround with those?

> Using PIO on some first sectors will avoid the issue.

> Regards,
> Thang Nguyen -

MBR, Sergei
