Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab2GDTfC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 15:35:02 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60908 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab2GDTe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 15:34:56 -0400
Message-ID: <4FF49AD7.20102@redhat.com>
Date: Wed, 04 Jul 2012 21:34:47 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] ata: implement MODE SELECT command
References: <1341400436-2546-1-git-send-email-pbonzini@redhat.com> <4FF4637A.6060901@mvista.com> <4FF46951.7050808@redhat.com> <4FF47B71.4030603@mvista.com>
In-Reply-To: <4FF47B71.4030603@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/07/2012 19:20, Sergei Shtylyov ha scritto:
>> > Perhaps for MODE SENSE, but not for MODE SELECT.  Otherwise, where do
>> > you get the mode data from?
>    They simply don't change?

The standard says "If the parameter list length results in the
truncation of any mode parameter header, mode parameter block
descriptor(s), or mode page, then the command shall be terminated with
CHECK CONDITION status, with the sense key set to ILLEGAL REQUEST, and
the additional sense code set to PARAMETER LIST LENGTH ERROR".

Paolo
