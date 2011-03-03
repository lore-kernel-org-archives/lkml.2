Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427Ab1CCQIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 11:08:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758196Ab1CCQIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 11:08:17 -0500
MIME-Version: 1.0
In-Reply-To: <20110303154706.GA22560@redhat.com>
References: <20110302162650.GA26810@redhat.com> <20110302162712.GB26810@redhat.com>
 <20110303114952.B94B.A69D9226@jp.fujitsu.com> <20110303154706.GA22560@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 Mar 2011 08:07:22 -0800
Message-ID: <AANLkTimp=mhedXLdrZFqK2QWYvg7MdmUPj3-Q9m2vtTx@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] exec: introduce get_arg_ptr() helper
To: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 7:47 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> I _personally_ don't like "conditional". Its name is based on code logic.
>> It's unclear what mean "conditional". From data strucuture view, It is
>> "opaque userland pointer".
>
> I agree with any naming, just suggest a better name ;)

Maybe just "struct user_arg_ptr" or something?

                        Linus
