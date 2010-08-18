Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab0HRPal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:30:41 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58486 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab0HRPaj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:30:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GG4iZVLdAnKQ+8QzW7/GsFdfokKr0JsCzPueCliZ4sRUM4/9UKtSt3boHzUlLVWUHf
         XCV8A+Hhyq0EhNSxAFeLtVh7GYoPI9l4yPBf9SdmfYQNVvqO4oYfY2Wl3nA78WqPeqTn
         lUXhPFeVpLHJWtsMwcuqx22iRUdyCCoh4/onM=
MIME-Version: 1.0
In-Reply-To: <AANLkTimJGxn=5kEMH68XVWqFcYG3vpfLjLjZpFGqhG_4@mail.gmail.com>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
	<1282144271.3035.31.camel@mulgrave.site>
	<AANLkTimJGxn=5kEMH68XVWqFcYG3vpfLjLjZpFGqhG_4@mail.gmail.com>
Date: Wed, 18 Aug 2010 17:30:33 +0200
X-Google-Sender-Auth: 9MDhInCL3YQ6XZGbHFADtB2cdoY
Message-ID: <AANLkTinARwxMat+YA0XsKTozdvh5Tta8_CDhZ8bM-NMa@mail.gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
From: Bart Van Assche <bvanassche@acm.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Chetan Loke <generationgnu@yahoo.com>,
        Vladislav Bolkhovitin <vst@vlnb.net>,
        scst-devel <scst-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 5:11 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
>
> On Wed, 2010-08-18 at 07:58 -0700, Chetan Loke wrote:
> > [ ... ]
> >
> > During the open panel, my question was really specific -
> >
> > Q) What is the future of a SCSI-target subsystem in linux. Which
> >    target engine/subsystem can we expect?
> >
> > Your answer) There is place for only 1 target-subsystem in the Linux
> > scsi stack and in the LSF summit the decision was taken to merge LIO.
> > Has that
> > decision changed since the summit?
>
> The decision hasn't been taken to merge LIO, but based on what happened
> at the summit, I think it's the most viable candidate and will likely be
> merged by 2.6.37

(resending as plain text)

No matter which kernel-based storage target subsystem is merged, a
migration path should be provided for SCST users such that these can
continue using their SCST target drivers without too much trouble.
Otherwise you'll upset a large number of SCST users.

Note: an SCST target driver is the code that implements a storage
protocol. See also http://scst.sourceforge.net/scst_pg.html for a
overview diagram.

Bart.
