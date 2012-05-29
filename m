Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab2E2Qe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:34:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39391 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab2E2Qez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:34:55 -0400
MIME-Version: 1.0
In-Reply-To: <1338308088.2202.39.camel@joe2Laptop>
References: <1336004953.4240.9.camel@mop> <20120526111143.GA32304@lizard>
 <CAPXgP10--rmzK8joBSrs3Abk7uuamJTDBbvrm6W6w_xODqZVtg@mail.gmail.com>
 <1338307620.886.21.camel@mop> <1338308088.2202.39.camel@joe2Laptop>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 29 May 2012 18:34:33 +0200
Message-ID: <CAPXgP11G17ty8rCB8qhJtXCVpbvzdoT-VT_p2c4i3jMrkGDRYw@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Joe Perches <joe@perches.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 6:14 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2012-05-29 at 18:07 +0200, Kay Sievers wrote:

>> +bool kmsg_dump_get_line(struct kmsg_dumper *dumper, bool syslog,
>> +                       const char *line, size_t size, size_t *len)
>> +{
>> +     return false
>> +}
>
> uncompilable.

The damn !CONFIG_PRINTK case. :) Fixed!
  http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=commitdiff;h=607b6e8fa7ca61dd385d632fe51c6afc5f5374b7

Thanks,
Kay
