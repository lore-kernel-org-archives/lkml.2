Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab2GZN4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 09:56:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab2GZN4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 09:56:04 -0400
Message-ID: <50114C6C.4070102@redhat.com>
Date: Thu, 26 Jul 2012 15:55:56 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 0/2] ata: MODE SELECT implementation
References: <1341481235-12708-1-git-send-email-pbonzini@redhat.com> <5010F104.5080606@redhat.com> <50114A64.8090500@pobox.com>
In-Reply-To: <50114A64.8090500@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 26/07/2012 15:47, Jeff Garzik ha scritto:
>>>
>>>
>>> Paolo Bonzini (2):
>>>    ata: support MODE SENSE request for changeable parameters
>>>    ata: implement MODE SELECT command
>>>
>>>   drivers/ata/libata-scsi.c |  242
>>> +++++++++++++++++++++++++++++++++++++++++----
>>>   1 files changed, 221 insertions(+), 21 deletions(-)
>>>
>>
>> Ping, no love for these? :)
> 
> These will go in #upstream for the next kernel...

Ok, thanks (BTW I pinged v2 but there is a v3 too).

Paolo

