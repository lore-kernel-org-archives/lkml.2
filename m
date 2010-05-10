Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab0EJKSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 06:18:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:46811 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab0EJKSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 06:18:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kVseb+1uM+DtbicnQeqPR2t7Cf31Jrdk3VBS1FkIV38SsbCXY3gu7v7lV5Qtf5qIg/
         6OvSbSB0rc0OBL+QxntF/Hf8igNsc0vpLSsHVMol6b7fvgXpTi8awW++o28wScIfvaVh
         Xihl2RgOxrtvKzE2BdW9GrkIcijY1j8aLJvZE=
MIME-Version: 1.0
In-Reply-To: <20100510045252.GC3387@windriver.com>
References: <AANLkTikTPkLID3e8HpT1jMeiF9tQ6-7oJWQBfiRF7xUN@mail.gmail.com>
	 <20100510045252.GC3387@windriver.com>
Date: Mon, 10 May 2010 12:18:38 +0200
Message-ID: <AANLkTimOrMLWXV8L0V6LQuZLa4QO-adOlxNH190YyU6u@mail.gmail.com>
Subject: Re: May the worker function free its struct_work (plus container)?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Yong Zhang <yong.zhang@windriver.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Yong,

On Mon, May 10, 2010 at 6:52 AM, Yong Zhang <yong.zhang@windriver.com> wrote:
> On Mon, May 10, 2010 at 12:47:23AM +0200, Leon Woestenberg wrote:
>> Hello,
>>
>> may the worker function kfree() it's own work data structure?
>
> Actually, workqueue has no restriction on this kind of operation.
> But if you must be careful with the caller in case it will refer
> the freed struct.
>
Thanks. Is there API documentation or source code documentation that
confirms this is the case?

I would hate to write code that gets buggy due to the underlying
implementation assuming the work structure is available after the
worker function returned.

Regards,
-- 
Leon
