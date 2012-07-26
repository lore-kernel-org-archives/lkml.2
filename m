Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab2GZNrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 09:47:22 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42817 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2GZNrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 09:47:20 -0400
Message-ID: <50114A64.8090500@pobox.com>
Date: Thu, 26 Jul 2012 09:47:16 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 0/2] ata: MODE SELECT implementation
References: <1341481235-12708-1-git-send-email-pbonzini@redhat.com> <5010F104.5080606@redhat.com>
In-Reply-To: <5010F104.5080606@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 03:25 AM, Paolo Bonzini wrote:
> Il 05/07/2012 11:40, Paolo Bonzini ha scritto:
>> This is a revised version of the MODE SELECT implementation from yesterday,
>> augmented with support for changeable parameter requests in MODE SENSE.
>>
>> Paolo Bonzini (2):
>>    ata: support MODE SENSE request for changeable parameters
>>    ata: implement MODE SELECT command
>>
>>   drivers/ata/libata-scsi.c |  242 +++++++++++++++++++++++++++++++++++++++++----
>>   1 files changed, 221 insertions(+), 21 deletions(-)
>>
>
> Ping, no love for these? :)

These will go in #upstream for the next kernel...

	Jeff





