Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198Ab0CSFor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 01:44:47 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45005 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab0CSFoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 01:44:46 -0400
Message-ID: <4BA30F3D.4020604@cs.helsinki.fi>
Date: Fri, 19 Mar 2010 07:44:29 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Lars Lindley <lindley@coyote.org>
CC: gregkh@suse.de, greg@kroah.com, pavel@ucw.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mlmetxrx_f.h Coding style fixes.
References: <1268927857-14141-1-git-send-email-lindley@coyote.org> <4BA254BC.6090507@cs.helsinki.fi> <4BA2A68D.9050401@coyote.org>
In-Reply-To: <4BA2A68D.9050401@coyote.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars Lindley wrote:
> On 2010-03-18 17:28, Pekka Enberg wrote:
>> Lars Lindley wrote:
>>> I fixed all problems found by checkpatch.pl and removed CamelCase
>>> from argument names.
> ..snip..
>>> +void MLME_GetNextPacket(struct wbsoft_priv *adapter,
>>> +            struct wb35_descriptor *pdes);
>> Can we get rid of the "p" prefix (hungarian notation) while at it?
>>
> Sure..
> I changed pdes to des, pmmpdu to mmpdu and widx to idx.
> Looks all right?
> 
> /Lars

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
