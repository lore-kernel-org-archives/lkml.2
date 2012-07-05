Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab2GEToD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:44:03 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42990 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab2GEToB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 15:44:01 -0400
Message-ID: <4FF5EE29.6020706@mvista.com>
Date: Thu, 05 Jul 2012 23:42:33 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH v2 2/2] ata: implement MODE SELECT command
References: <1341481235-12708-1-git-send-email-pbonzini@redhat.com> <1341481235-12708-3-git-send-email-pbonzini@redhat.com> <4FF57DAA.8010405@mvista.com> <4FF58320.1050606@redhat.com>
In-Reply-To: <4FF58320.1050606@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/05/2012 04:05 PM, Paolo Bonzini wrote:

>>> +
>>> +    /*
>>> +     * No mode subpages supported (yet) but asking for _all_
>>> +     * subpages may be valid
>>> +     */
>>> +    if (spg && (spg != ALL_SUB_MPAGES))
>>> +        goto invalid_param;

>>    Rather "paramater not supported" (0x26/0x01)...

> SCSI spec begs to differ... there is no reference to that sense code in
> the whole SPC spec.

   Right you are, I was just picking the more fitting ASC/ASCQ from the table
instead of reading the command description itself. :-<

MBR, Sergei
