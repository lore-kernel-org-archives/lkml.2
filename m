Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab1DVXaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 19:30:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752862Ab1DVXaK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 19:30:10 -0400
MIME-Version: 1.0
In-Reply-To: <1303507049.2441.3.camel@unknown001a4b0c2895>
References: <1303431801-10540-1-git-send-email-andi@firstfloor.org>
 <BANLkTi=kod0vH3Ybb4Fe=Sa5zvzYSmoj1Q@mail.gmail.com> <1303507049.2441.3.camel@unknown001a4b0c2895>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 22 Apr 2011 16:29:43 -0700
Message-ID: <BANLkTinDY2i5+gG3Ggd8mDMxJmZ2fbXYBw@mail.gmail.com>
Subject: Re: Make RCU dcache work with CONFIG_SECURITY=y
To: Eric Paris <eparis@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        npiggin@kernel.dk, shaohua.li@intel.com, sds@tycho.nsa.gov,
        jmorris@namei.org, linux-security-module@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 2:17 PM, Eric Paris <eparis@redhat.com> wrote:
> On Fri, 2011-04-22 at 11:26 -0700, Linus Torvalds wrote:
>>
>> Comments? I'd really like to see/hear feedback like "yeah, this looks
>> really obviously safe" vs "yeah, looks good, but I really don't feel
>> very comfortable with it" from the security people.
>
> From an SELinux PoV (And I feel semi confident about SMACK) patch 1/3
> can and should go in as soon as you want.  2/3 looked safe on first
> glance, but I think I can make it smaller and better.  I'll try to get a
> version of 2/3 on list in the next couple of days.  My first thought was
> that it should probably go in via my SELinux tree next window......

Ok, given the pretty obvious nature of 1/3 and no objections, I
committed that one.

Let's see what the situation with 2/3 is. It would be good to not have
slower path lookup for all the selinux-using people, but whatever.

                     Linus
