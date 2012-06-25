Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab2FYTfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 15:35:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44775 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab2FYTfY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 15:35:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120625192007.GA1005@kroah.com>
References: <4FE4AD09020000780008B77F@nat28.tlf.novell.com>
 <CAPXgP13nd7k3v3YGcW9F45L8LhT5tctw64jaooUwQ8=ypfVH+g@mail.gmail.com>
 <4FE829CD020000780008B9DB@nat28.tlf.novell.com> <20120625192007.GA1005@kroah.com>
From: Kay Sievers <kay@vrfy.org>
Date: Mon, 25 Jun 2012 21:35:03 +0200
Message-ID: <CAPXgP11rkrk5LBYswPf_3nOD2e2oYnvWgbFb81NYgjta67Dj3w@mail.gmail.com>
Subject: Re: [PATCH] syslog: fill buffer with more than a single message for SYSLOG_ACTION_READ
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jan Beulich <JBeulich@suse.com>, yuanhan.liu@linux.intel.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 9:20 PM, Greg KH <gregkh@linuxfoundation.org> wrote:

> Ok, so I'm confused, you want me to apply this patch and then revert a
> different one?  Which one, 4a77a5a06ec66ed05199b301e7c25f42f979afdc?

b56a39ac conflicts and is replaced with that patch.
4a77a5a0 should stay, as it fixes an actual problem, even with the old
code, I think.

> Kay, do you agree?

Yes, seems, we need to restore the old behaviour, even when it's worse
than the current one. The stuff SUSE does here really doesn't sound
right, but it's history done long ago, and we an not change that.

Thanks,
Kay
