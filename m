Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab1KHHHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 02:07:41 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62870 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab1KHHHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 02:07:38 -0500
MIME-Version: 1.0
In-Reply-To: <20111108110300.e8494242e6c404142b1fe4c0@canb.auug.org.au>
References: <20111107172408.834c6ffcecfe35f7452c7e60@canb.auug.org.au>
	<1320677484.1215.10.camel@dabdike.int.hansenpartnership.com>
	<20111108110300.e8494242e6c404142b1fe4c0@canb.auug.org.au>
Date: Tue, 8 Nov 2011 08:07:37 +0100
X-Google-Sender-Auth: CDt-R746TQlO4VhFULDfPy0tMjE
Message-ID: <CAO+b5-pPTt9B1se3-oGrZZ4-mScJh7_9MA29UTbOSB3QR4L38A@mail.gmail.com>
Subject: Re: WARNING: at drivers/scsi/scsi_lib.c:1704
From: Bart Van Assche <bvanassche@acm.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 1:03 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Mon, 07 Nov 2011 08:51:24 -0600 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>> The true fix is to do a proper
>> teardown instead of hand rolling it.  Does this fix it for you?
>
> I don't get the WARNING any more, but now get lots of:
>
> scsi: killing requests for dead queue

This patch should help: http://www.spinics.net/lists/linux-scsi/msg55373.html.

Bart.
