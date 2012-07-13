Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917Ab2GMKbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 06:31:06 -0400
Received: from service88.mimecast.com ([195.130.217.12]:45178 "EHLO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463Ab2GMKbF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 06:31:05 -0400
Message-ID: <4FFFF8E1.20408@arm.com>
Date: Fri, 13 Jul 2012 11:30:57 +0100
From: viresh kumar <viresh.kumar2@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: viresh kumar <viresh.kumar@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH 3/3] dw_dmac: set default alignment
References: <1342166974-4490-1-git-send-email-andriy.shevchenko@linux.intel.com> <1342166974-4490-3-git-send-email-andriy.shevchenko@linux.intel.com> <CAOh2x=k6MDt5arZfPgrn8_tPu_zgPsD2e5y0-JyUkrx71Z6BNQ@mail.gmail.com> <CAHp75VfiyLJKdSogHRDqU1TC-3icKAhCXa0hWbfnWEcNmJosTQ@mail.gmail.com> <4FFFE2B3.3040306@arm.com> <CAHp75Vde==tJU9DrKwvWv1OezdO+YiEUAZAbiuvs0wAgUwwmYQ@mail.gmail.com>
In-Reply-To: <CAHp75Vde==tJU9DrKwvWv1OezdO+YiEUAZAbiuvs0wAgUwwmYQ@mail.gmail.com>
X-MC-Unique: 112071311310101002
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/07/12 11:04, Andy Shevchenko wrote:
> On Fri, Jul 13, 2012 at 11:56 AM, viresh kumar <viresh.kumar2@arm.com> wrote:
>> I wanted to ask, will normal memcpy for anybody will work with unaligned addresses
>> with this patch? I believe they will.
> Hmm... I just rechecked and it seems it works without this patch. I
> didn't remember why this patch still in my pool.

Sorry, got confused now. What works without this patch? And what doesn't work without it?

--
Viresh

-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

