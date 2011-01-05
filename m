Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab1AEPnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 10:43:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36808 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab1AEPnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 10:43:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ODvM1Kf707fNXcDgY2JJCUmvC8o3XK9pnvb/DvEpb108m891GCBucBdeuPnmQwfwSc
         FmCChKBF+X2Coqnc+ffoz2cj1hKs35TN5JApPymF+qlfMSxQEJe237nvXDEm1FO1ISJv
         Mgg1JZgjLH02w69qXM9Szv62GAszjtvkwm+Bo=
MIME-Version: 1.0
In-Reply-To: <4D2487F9.8030704@redhat.com>
References: <4CFF3DA4.5060705@jp.fujitsu.com>
	<4CFF9A2C.1070401@fusionio.com>
	<4D025154.8030400@redhat.com>
	<20101210165553.GE31737@redhat.com>
	<4D07D2AC.6000500@fusionio.com>
	<4D0B68AF.80804@redhat.com>
	<4D0BB4A1.8080305@fusionio.com>
	<4D13664C.3020500@redhat.com>
	<20101223153915.GE9502@redhat.com>
	<4D13810B.8000304@redhat.com>
	<20101224192916.GB2082@redhat.com>
	<4D23423A.60707@redhat.com>
	<1294157114.3579.102.camel@edumazet-laptop>
	<4D2487F9.8030704@redhat.com>
Date: Wed, 5 Jan 2011 17:43:22 +0200
Message-ID: <AANLkTinnVv5wE0U=RrSKR40-u88VC8_XMctx=X0O3Tg7@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] kref: add kref_test_and_get
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 5, 2011 at 5:02 PM, Jerome Marchand <jmarchan@redhat.com> wrote:
> Add kref_test_and_get() function, which atomically add a reference only if
> refcount is not zero. This prevent to add a reference to an object that is
> already being removed.

Is kref supposed to be used only for "toy" structures where you aren't
expected to do get possibly dead object?
