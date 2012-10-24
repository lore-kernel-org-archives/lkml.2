Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab2JXJRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:17:47 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446Ab2JXJRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:17:45 -0400
Message-ID: <5087B236.5060804@nod.at>
Date: Wed, 24 Oct 2012 11:17:42 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Matthew Leach <matthew@mattleach.net>
CC: linux-kernel@vger.kernel.org,
        =?UTF-8?B?TWFydGluIFDDpHJ0ZWw=?= <martin.partel@gmail.com>
Subject: Re: [REGRESSION] uml: signal.c build errors
References: <87pq48lqut.fsf@mattleach.net> <5087A203.4060505@nod.at> <87txtkgrsw.fsf@mattleach.net>
In-Reply-To: <87txtkgrsw.fsf@mattleach.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.10.2012 11:09, Matthew Leach wrote:
> Hi Richard,
>
> Richard Weinberger <richard@nod.at> writes:
>>
>> Does this patch fix the issue?
>
> Your patch fixed the initial error, but I now get:

Okay, we have to get rid of all struct sig_infos.
A patch is on the way.

Thanks,
//richard

