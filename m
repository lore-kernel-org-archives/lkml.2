Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab0CWCrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 22:47:35 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:21435 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab0CWCre convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 22:47:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HCUJXVD2IrjvNnquwa06h//a3SMuzK+SaZQlp+Hl3FVtYguzygGP6yiMvPk8WvskGh
         PQbcgBa7Rpdw/KQwXqlc7rB0gSS9QnrTUZWzFW1PEGdtoqbnII6BwAPlRt251BiG7JBs
         vo7B15TIDWp6AsKXxkT19JVuGTtDfNk9hElhk=
MIME-Version: 1.0
In-Reply-To: <20100323091841.dd500a38.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100322120509.GC21571@bicker>
	 <20100323091841.dd500a38.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 23 Mar 2010 10:47:33 +0800
Message-ID: <2375c9f91003221947n4d4f417w3a5ea32565e9c582@mail.gmail.com>
Subject: Re: [patch] kcore: fix test for end of list
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Dan Carpenter <error27@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 8:18 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Mon, 22 Mar 2010 15:05:09 +0300
> Dan Carpenter <error27@gmail.com> wrote:
>
>> "m" is never NULL here.  We need a different test for the end of list
>> condition.
>>
>> Signed-off-by: Dan Carpenter <error27@gmail.com>
>
> yes, thank you.
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Yeah, this is a good catch for me too!

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
