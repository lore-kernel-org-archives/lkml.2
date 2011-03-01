Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab1CAVRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 16:17:51 -0500
Received: from usmamail.tilera.com ([206.83.70.70]:45122 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab1CAVRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 16:17:50 -0500
Message-ID: <4D6D627D.1030705@tilera.com>
Date: Tue, 1 Mar 2011 16:17:49 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: catch up with section naming convention in
 2.6.35
References: <201103011931.p21JVtqp010237@farm-0010.internal.tilera.com> <201103011934.p21JYbHc010296@farm-0010.internal.tilera.com> <20110301205234.GA5605@merkur.ravnborg.org>
In-Reply-To: <20110301205234.GA5605@merkur.ravnborg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/1/2011 3:52 PM, Sam Ravnborg wrote:
> Hi Chris.
>
> A few improvement proposals.
>
>> [...]
> Here you could use
>
>     __PAGE_ALIGNED_BSS
>> [...]
> and here you could use
>
>     __PAGE_ALIGNED_DATA
>> [...]
>     __page_aligned_bss

Thanks!  I updated the change to use the symbolic names.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

