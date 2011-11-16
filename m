Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab1KPBZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 20:25:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41093 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab1KPBZx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 20:25:53 -0500
MIME-Version: 1.0
In-Reply-To: <CABqxG0dNoXjpOtug62TLX+as0CAt_niQc=msZTh+heLv8zLQyg@mail.gmail.com>
References: <20111115083646.GA21468@darkstar.nay.redhat.com>
	<20111115144943.GJ30922@google.com>
	<CABqxG0dNoXjpOtug62TLX+as0CAt_niQc=msZTh+heLv8zLQyg@mail.gmail.com>
Date: Tue, 15 Nov 2011 17:25:51 -0800
X-Google-Sender-Auth: jwWurYR0RCAOqKqqhuQLnY672jw
Message-ID: <CAOS58YNk8fymqknAz2autsZF=AFsG0KOef3kAC=avUJiKVPuag@mail.gmail.com>
Subject: Re: [PATCCH percpu: add cpunum param in per_cpu_ptr_to_phys
From: Tejun Heo <tj@kernel.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Dave Young <dyoung@redhat.com>, gregkh@suse.de, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 15, 2011 at 5:15 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>> Does this matter?  If it's not a performance critical path, I'd rather
>> keep the generic funtionality.
>
> Hi, why not? the code is redundant, it's an improvement of the code, isn't it?
> Also, kernel code size will be smaller.

(scratching head...) Ummm... I'm not sure whether it's an improvement
or not. The contest is between loss of currently unused functionality
and meaningless optimization. I vote for status quo.

Thanks.

-- 
tejun
