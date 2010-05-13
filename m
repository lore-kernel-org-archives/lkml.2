Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759159Ab0EMPoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:44:39 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:60937 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759121Ab0EMPoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=jQJ+74LbIY0x0pFKud6AZ0WkJvPSmnVxqNvGgK89O7BLqipUaSHAovZxdl3Ljpe7jx
         oaEAhMsRyaKn49OJ5JTkPo8nTcaUguXIgd5YiMl3ATLt/SZRE89BMlRetrvls0lWOOhU
         MiBHdq35K83gg032SFt5b6xfE3FTjF2AP7nh0=
Date: Thu, 13 May 2010 23:48:21 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: =?utf-8?B?QW5kcsOp?= Goddard Rosa <andre.goddard@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Sanchin Sant <sanchinp@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mqueue: fix kernel BUG caused by double free() on
 mq_open()
Message-ID: <20100513154821.GB5132@cr0.redhat.com>
References: <17ea945f6d53443000524eb7cc5c4fc66ee3ecf8.1273396690.git.andre.goddard@gmail.com>
 <20100512083706.GE5718@cr0.nay.redhat.com>
 <AANLkTinDz8zNrFcziMvpHOLLujYK9AEeQ10uWrrrMC5e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinDz8zNrFcziMvpHOLLujYK9AEeQ10uWrrrMC5e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 08:17:30AM -0300, André Goddard Rosa wrote:
>Hi, Américo!
>
>> In the latest git, you already removed the above kfree() since it is
>> not necessary. mqueue_delete_inode() will kfree it.
>> so why this fix though?
>
>The applied patch is a newer/better version. This is an old version,
>please just ignore it. Thank you!

Oh, sorry. Yeah, the fix in git is better.

Thanks.
