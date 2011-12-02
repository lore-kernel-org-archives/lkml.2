Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157Ab1LBFAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 00:00:11 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50275 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1LBFAJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 00:00:09 -0500
MIME-Version: 1.0
In-Reply-To: <4ED8039F.4090104@mit.edu>
References: <CAGPN=9Q8gB_xsbB1BrMJSo_Qs=7Tu49RX4x3VqNB9adzVdm6kg@mail.gmail.com>
	<4ED8039F.4090104@mit.edu>
Date: Fri, 2 Dec 2011 06:00:09 +0100
Message-ID: <CAGPN=9T2tSK43NgMA=6T=jUqBnOT-6PXq8FeQXjSgGoDW1==1A@mail.gmail.com>
Subject: Re: i915: RC6 causes sudden shutdowns
From: Patrik Kullman <patrik.kullman@gmail.com>
To: Andy Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/1 Andy Lutomirski <luto@mit.edu>:
> On 11/23/2011 03:43 PM, Patrik Kullman wrote:
>> Hi,
>>
>> I recently acquired the Asus Zenbook UX31E but have been looking for
>> ways to extend the battery life.
>>
>> I read that the i915_enable_rc6 parameter could decrease power usage
>> significantly and tried it with the 3.1.1 and 3.1.2 kernels, and
>> indeed it does.
>> However, I (and the other Zenbook-owners from the Ubuntu forums)
>> experience sudden, unexpected shutdowns (for me, 1-4 times per day)
>> with this parameter.
>> It's as sudden as a power loss.
>
> Do you have DMAR enabled?  If so, it's a known problem and it's being
> worked on (and the default will not change for you AFAICT).  If not, you
> should send a bug report to the intel-gfx -- several people there care
> about this.
>
> --Andy

Well, it's not something I've explicitly enabled.

Is it on by default?

If so, any reason why I wouldn't want to disable it?
