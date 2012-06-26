Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab2FZAfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:35:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39387 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821Ab2FZAfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:35:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120626000148.GA3896@kroah.com>
References: <4FE4AD09020000780008B77F@nat28.tlf.novell.com>
 <CAPXgP13nd7k3v3YGcW9F45L8LhT5tctw64jaooUwQ8=ypfVH+g@mail.gmail.com>
 <4FE829CD020000780008B9DB@nat28.tlf.novell.com> <20120625192007.GA1005@kroah.com>
 <CAPXgP11rkrk5LBYswPf_3nOD2e2oYnvWgbFb81NYgjta67Dj3w@mail.gmail.com> <20120626000148.GA3896@kroah.com>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 26 Jun 2012 02:34:49 +0200
Message-ID: <CAPXgP10iHmADRGQ8TvmWG3-LB7PhoVFcRTF7PDPq29CWQNu65w@mail.gmail.com>
Subject: Re: [PATCH] syslog: fill buffer with more than a single message for SYSLOG_ACTION_READ
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jan Beulich <JBeulich@suse.com>, yuanhan.liu@linux.intel.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 2:01 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Jun 25, 2012 at 09:35:03PM +0200, Kay Sievers wrote:
>> On Mon, Jun 25, 2012 at 9:20 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>> > Ok, so I'm confused, you want me to apply this patch and then revert a
>> > different one?  Which one, 4a77a5a06ec66ed05199b301e7c25f42f979afdc?
>>
>> b56a39ac conflicts and is replaced with that patch.
>> 4a77a5a0 should stay, as it fixes an actual problem, even with the old
>> code, I think.
>
> Ok, I'm even more confused now.  Maybe I just need more coffee.
>
> Can you list what exactly I should do here?  Should I apply this patch?
> Revert some other patch?  Which one(s)?

Revert b56a39ac (return -EINVAL) and apply the patch from Jan. The
problem b56a39ac solved , is replaced by other logic in Jan's patch.

Kay
