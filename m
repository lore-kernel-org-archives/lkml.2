Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab0FRGJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 02:09:20 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46884 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab0FRGJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 02:09:19 -0400
Message-ID: <4C1B0D8C.1030906@cs.helsinki.fi>
Date: Fri, 18 Jun 2010 09:09:16 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: wzt wzt <wzt.wzt@gmail.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mpm@selenic.com
Subject: Re: [PATCH] Slabinfo: Fix display format
References: <20100617155420.GB2693@localhost.localdomain>	<alpine.DEB.2.00.1006170844300.22997@router.home> <AANLkTimYX9PqGJq3dw2n3FZQiIkX0nOKMEOHdYMndHWo@mail.gmail.com>
In-Reply-To: <AANLkTimYX9PqGJq3dw2n3FZQiIkX0nOKMEOHdYMndHWo@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/17/10 5:10 PM, wzt wzt wrote:
> On Thu, Jun 17, 2010 at 9:45 PM, Christoph Lameter
> <cl@linux-foundation.org>  wrote:
>> On Thu, 17 Jun 2010, wzt.wzt@gmail.com wrote:
>
>> This one may break user space tools that have assumptions about the length
>> of the field. Or do tools not make that assumption?
>
> User space tools usually use sscanf() to extract this field like:
> sscanf(buff, "%s %d", name,&num);
> If %-27s can break some user space tools that have assumptions about
> the length of the field, the orig %-17s can also break it.
> The longest name inotify_event_private_data is 26 bytes in 2.6.34-rc2,
> the tools still can't extract it.

NAK. It's an ABI so the risks of this format cleanup outweight the benefits.

			Pekka
