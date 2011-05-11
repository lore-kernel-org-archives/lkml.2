Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab1EKQAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:00:43 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50626 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764Ab1EKQAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:00:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=j+AwpWrn5JXc/dOm0b8zE2yrcD6kTgc/UmzpnK6pcnZrs7rVlXHYrUDq9Ab9/F1ZoQ
         tCO2S9J78OTX0BSFrqkVoic1gpg7owE8OpZzN4YIxIHx1YfBmu4iz1PEUoWWRM+jJyPM
         EaEp68QANQmvTghkmT8EKVeHj5r4sJc1LHG+E=
MIME-Version: 1.0
In-Reply-To: <20110511134730.GA12717@kroah.com>
References: <20110510074421.GA2755@maxin>
	<4DC97BD0.6040403@slagter.name>
	<BANLkTi=OQ=ahXW2n=ww4ZZ8vK4=mv6Kc7A@mail.gmail.com>
	<4DCA5FBF.1050009@slagter.name>
	<20110511134730.GA12717@kroah.com>
Date: Wed, 11 May 2011 15:13:37 +0100
Message-ID: <BANLkTi=ty_LMx4mvRXt5v=6-TxUyZir4oA@mail.gmail.com>
Subject: Re: [PATCH 001/001]: USB: cdc_acm: Fix oops when Droids MuIn LCD is connected
From: Maxin B John <maxin.john@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Erik Slagter <erik@slagter.name>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> If Maxin created it, it should have his "From:" on the top, right?

It was a combined effort. I think, Erik has done the core part of it.

> And did Maxin really sign-off-by: on the patch?  You can not add other
> people's names to that without them really doing it, that's not allowed
> at all.

Yes. I have added the "sign-off-by:" by myself. While we were developing and
testing the patch, we have agreed to share the fame/blame together.

> Care to redo it?
Should we really re-do it for the "sign-off-by" issue ? If it is
really required,
we are ready to redo it.

Best Regards,
Maxin
