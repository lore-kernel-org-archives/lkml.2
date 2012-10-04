Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab2JDHe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 03:34:56 -0400
Received: from nm20-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.218]:35850 "HELO
	nm20-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753648Ab2JDHez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 03:34:55 -0400
X-Yahoo-Newman-Id: 884108.62530.bm@omp1016.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: xki1pg8VM1kBtBq8Bh2kKpF.YCCMzhRH_n2iSMJGtRSFm5x
 GWEVd8MLeJip3c2ASiCK4wEvVoq3IyVBz63rYYUwBiioI.1iHHpF8jhftqi5
 _U9tJ9irq3RWxi8HXa2uXgIn2YkcMAi5djdq3th0JhIHboMJN6Ipqtew0jYL
 kJogQip_D0B9uvc_NbGGgjDfgfdih4WOpCj8G2qtE_x7q6wtgbu4PskwgKtl
 gJucbFfB7MpcraQ0jOA1SZIPaFuZ4nZ9ttwgE4rhyVTQMGze6vPQjnGjqlim
 FXsAKSeRneIOQqjN65mX.EcSsFM1tMCLJslPgc3.mOM4yfpjmF_N_93aYL7P
 K6lNAwsrGrfcD9JWL_0GPBbT_.WlzCbwm0lqFh.TmUNvTlKSsZoi3iUC8RIC
 E.6HY1WOUTERB.qfi8M.qAMxoiZRAmKbYHYGDhT73m9BVHOp0Mg--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <506D3C1E.4050704@att.net>
Date: Thu, 04 Oct 2012 02:34:54 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 48241] New: oops when setting up LVM (3.6.0-next-20121003)
References: <bug-48241-11613@https.bugzilla.kernel.org/> <1349277786.2404.24.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1349277786.2404.24.camel@dabdike.int.hansenpartnership.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 10:23 AM, James Bottomley wrote:
> On Wed, 2012-10-03 at 15:04 +0000, bugzilla-daemon@bugzilla.kernel.org
> wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=48241
>>
>>            Summary: oops when setting up LVM
>>            Product: IO/Storage
>>            Version: 2.5
>>     Kernel Version: 3.6.0-next-20121003
>>           Platform: All
>>         OS/Version: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: normal
>>           Priority: P1
>>          Component: SCSI
>>         AssignedTo: linux-scsi@vger.kernel.org
>>         ReportedBy: daniel.santos@pobox.com
>>         Regression: No
>>
>>
>> Created an attachment (id=81921)
>>  --> (https://bugzilla.kernel.org/attachment.cgi?id=81921)
>> image of oops
>
> The image says the RIP is at kthread_data + 0xb
>
> That implies something went wrong within the workqueue or kthread
> systems, I've cc'd linux-kernel, but it's a bit of a vague thing to go
> on and could conceivably be a hardware issue (or some weird thread
> interaction in linux-next).
>
> The first question would be "does it happen in vanilla 3.6"?
>
> James
So just to CC LKML, works in vanilla 3.6.0, happens in both -next & -mm,
tried compiling with both gcc 4.6.3 & 4.7.1.

Daniel
