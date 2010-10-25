Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab0JYJpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 05:45:38 -0400
Received: from mail-zbox20.bo3.lycos.com ([209.202.250.20]:58833 "EHLO
	mailbox20.lycos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab0JYJph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:45:37 -0400
Date: Mon, 25 Oct 2010 05:45:13 -0400 (EDT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: Tejun Heo <htejun@gmail.com>
Cc: kevin granade <kevin.granade@gmail.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <234909.335371287999912985.JavaMail.root@mail-zbox20.bo3.lycos.com>
In-Reply-To: <4CC548F8.1090307@gmail.com>
Subject: Re: On Linux numbering scheme
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.16.118.77]
X-Mailer: Zimbra 5.0 (ZimbraWebClient - FF3.0 (Linux)/5.0.18_GA_3028.CentOS5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Tejun Heo" wrote:

> On 10/22/2010 04:00 AM, Al Viro wrote:
> > On Thu, Oct 21, 2010 at 07:06:23PM -0500, kevin granade wrote:
> > 
> >> Any particular reason not to continue the date-oriented format and
> >> have the third number be the numerical representation of the month
> >> rather than an incrementing numbering of the releases?  It would
> still
> >> be monotonically increasing, which is the only requirement, right?
> > 
> > Why do we need to change it, anyway?
> 
> Agreed.  These days, I use just the last digit, as in kernel 36, in
> casual contexts.  It's a number as good as any other.  I don't think
> it needs to be changed actively.  If the 2.6. prefix is bothering,
> just use the last number and maybe that will become semi-official in
> the future, or maybe not.  Doesn't really matter.
> 
> -- 
> tejun

That's my point. "2.6" prefix is totally meaningless nowadays. I just
want to rejuvenate the numbering scheme and make it easy to understand
and comprehend. What's the difference between .16 and .36? Besides, I
just think these huge numbers look unsightly. Do you know any other
piece of software which has the same huge numbers?
