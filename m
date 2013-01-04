Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab3ADTOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 14:14:17 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:40661 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab3ADTON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 14:14:13 -0500
Message-ID: <50E723EE.6070304@redhat.com>
Date: Fri, 04 Jan 2013 19:48:14 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>,
        Tejun Heo <tj@kernel.org>
Subject: Ping^2 Re: [PATCH v3 0/2] add per-device sysfs knob to enable unrestricted,
 unprivileged SG_IO
References: <1352827513-29890-1-git-send-email-pbonzini@redhat.com> <50CF2BE5.8070804@redhat.com>
In-Reply-To: <50CF2BE5.8070804@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/12/2012 15:27, Paolo Bonzini ha scritto:
> Il 13/11/2012 18:25, Paolo Bonzini ha scritto:
>> > Privilege restrictions for SG_IO right now apply without distinction to
>> > all devices, based on the single capability CAP_SYS_RAWIO.  This is a very
>> > broad capability, and makes it difficult to give SG_IO access to trusted
>> > clients that need access to persistent reservations, trim/discard, or
>> > vendor-specific commands.  One problem here is that CAP_SYS_RAWIO allows
>> > to escape a partition and issue commands that affect the full disk,
>> > thus making DAC almost useless.
>> > 
>> > For simplicity, this series attempts to solve one case only: you want
>> > to pass through almost everything, but still run as confined as possible.
>> > This is for example the case for virtualization, where more complex
>> > filtering can be done just as easily in userspace, in the virtual
>> > machine monitor.  (This does mean the filter can be subverted if the
>> > guest can escape the QEMU jail, but a more generic approach involving
>> > a bitmap was NACKed).
>> > 
>> > Ok for 3.8?
> Ping... Jens, I haven't seen any pull request for 3.8 from you.  Are
> these patches on your radar?  Tejun acked both of them.

Ping^2.

Paolo
