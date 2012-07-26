Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab2GZH0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 03:26:05 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63400 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab2GZH0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 03:26:02 -0400
Message-ID: <5010F104.5080606@redhat.com>
Date: Thu, 26 Jul 2012 09:25:56 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 0/2] ata: MODE SELECT implementation
References: <1341481235-12708-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1341481235-12708-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/07/2012 11:40, Paolo Bonzini ha scritto:
> This is a revised version of the MODE SELECT implementation from yesterday,
> augmented with support for changeable parameter requests in MODE SENSE.
> 
> Paolo Bonzini (2):
>   ata: support MODE SENSE request for changeable parameters
>   ata: implement MODE SELECT command
> 
>  drivers/ata/libata-scsi.c |  242 +++++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 221 insertions(+), 21 deletions(-)
> 

Ping, no love for these? :)

Paolo

