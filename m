Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab1FDPmk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 11:42:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58898 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479Ab1FDPmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 11:42:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:in-reply-to:mime-version:content-type:message-id
         :content-transfer-encoding:cc:from:subject:date:to:x-mailer;
        b=UqaTI9mQpjwkn1tJzLPwGHIrNVeuw76WJzQvFBrmt5URVsG4inKVV+6CXIUDAGEyTc
         dGfrpw/Y6wX45zJ841knXxe1Q8UokvOc3wGhCmp+79Q/+GZBKos2i0ViHlLl6oc9Cghm
         eHtds2yyqlHyj91M7gdvqJ0U9z4DGupJSbPGM=
References: <85F46CF9-5433-4623-91FC-9CD890082F69@gmail.com> <loom.20110604T081231-613@post.gmane.org>
In-Reply-To: <loom.20110604T081231-613@post.gmane.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <A0A243A9-9097-4EEA-B3EF-1D09C925AC81@gmail.com>
Content-Transfer-Encoding: 8BIT
Cc: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?Markus_H=E4stbacka?= <mhastbacka@gmail.com>
Subject: Re: rcu_kthread hang on 3.0.0-rc1-next-20110602
Date: Sat, 4 Jun 2011 18:41:43 +0300
To: Manuel Lauss <manuel.lauss@googlemail.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I compiled the kernel with preempt and the problem is indeed gone, the hd errors are still present from time to time, but thats probably a hardware problem.

M

On Jun 4, 2011, at 9:17 AM, Manuel Lauss wrote:

> Hello,
> 
> Markus Hästbacka <mhastbacka <at> gmail.com> writes:
>> If I
>> run dmesg  the computer hangs for 15 minutes, and I cannot even login at this
> time, if I leave top (the top
>> window updates very slowly, like every 5 minutes during this period) running I
> can see that the process
>> rcu_kthread takes 100% CPU, the computer load average is at around 10.
> 
>> but for example the last time I got the hang, I didn't get this error, nor any
> other error for that matter.
>> 
>> The OS is installed on a CF-card. The computer is a eBox computer with VIA
> Nehemiah CPU, 256MB RAM.
>> 
>> what more information do you need? Or what more can I test?
> 
> I too experience this weird 15 to 20-minute hang, but only on non-preempt
> uniprocessor kernels; it still responds to pings, though.
> With either preempt or SMP enabled it's not as visible or simply gone.
> 
> Manuel
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

