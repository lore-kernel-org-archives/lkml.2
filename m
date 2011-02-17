Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab1BQHtC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 02:49:02 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57995 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab1BQHsx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 02:48:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lf3uDkW456oVDZYvylmt99qZ93F6mdEeKjBfKEKpr2RTMDoOW0frW1ICHO7E8/A2b3
         59tn8Q5iqc+iv/n8PJYeXe6vSnW9vm8RPwsUaRgawWxSFMSHCt4Xn9/DqCqBwFq3/nvk
         nxO4HqI/hDP1T2mpLqfRaUWMwoxHB0EA0Aphw=
MIME-Version: 1.0
In-Reply-To: <AANLkTimh61U2WC1U0uwYmK0U4TvdkCLM6NcYoAju6tp0@mail.gmail.com>
References: <AANLkTikLVMNQzmugH-ORc89_ZouX6zWvG-tHSf1QoVf3@mail.gmail.com>
	<20110216115701.3956.qmail@science.horizon.com>
	<AANLkTimh61U2WC1U0uwYmK0U4TvdkCLM6NcYoAju6tp0@mail.gmail.com>
Date: Thu, 17 Feb 2011 10:48:51 +0300
Message-ID: <AANLkTikCSTJxJNzz_vn=eEy3QXufaJ_s+5U3MpAoWWDe@mail.gmail.com>
Subject: Re: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU 0.
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: George Spelvin <linux@horizon.com>, a.p.zijlstra@chello.nl,
        dzickus@redhat.com, eranian@google.com, linux-kernel@vger.kernel.org,
        ming.m.lin@intel.com, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 5:56 AM, Dave Airlie <airlied@gmail.com> wrote:
>>
>> It's appended below for your convenience.  Are you using this
>> unsuccessfully?
>
> This patch quoted below fixes it for me.
>
> No more spurious NMIs on my P4.
>
> Tested-by: Dave Airlie <airlied@redhat.com>
>

Thanks Dave! Ingo has merged it into -urgent branch, so it should
reach mainline soon.
