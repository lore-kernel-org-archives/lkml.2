Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab1EaKaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 06:30:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47677 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab1EaKad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 06:30:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=Qyfqk1dOBtggVB9nLVLSLB3waawja+ZGV2aAawtk5SKbhcax3zoEHs/YKw6stvf4O1
         Sp3U7PKEgzbbk4sg9LKOpdMg7nkDb0SLLTo2Yk7u4f4LkkBIC332eNDIVccp3Wc9xxfz
         zxrQZPYmfJ+qpZ7tHtlf7a0RazoxBGiDQ6YTQ=
MIME-Version: 1.0
In-Reply-To: <20110531101947.GA31648@lst.de>
References: <1306551592.23461.506.camel@haakon2.linux-iscsi.org>
 <BANLkTimt5qisV7EH7NMv1tG8gR_9d-kA3g@mail.gmail.com> <20110530130949.GB13494@lst.de>
 <BANLkTikdJcNPv4CV4nLuyuPtAYpCR1cp0Q@mail.gmail.com> <20110531101947.GA31648@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 31 May 2011 12:30:12 +0200
X-Google-Sender-Auth: eMFvRzEbT0M1GpzoozRN_ZEKkdU
Message-ID: <BANLkTikxHvR2TTHbaSdQo3cSP7=dpcsnHQ@mail.gmail.com>
Subject: Re: [GIT PULL] iscsi-target: Merge for .40-rc1
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Mike Christie <michaelc@cs.wisc.edu>, Andy Grover <agrover@redhat.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 12:19 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, May 30, 2011 at 05:13:22PM +0200, Bart Van Assche wrote:
>> And here is another issue that still hasn't been resolved yet:
>> http://marc.info/?l=linux-scsi&m=129707890023739&w=2.
>
> This is related to the software iSCSI fronted in what way?

I see this as a design bug that affects the target core and all target
drivers. As far as I know nobody has started resolving this issue yet
nor is there agreement about how it has to be resolved.

Bart.
