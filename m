Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab0EKAgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 20:36:21 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:48025 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab0EKAgT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 20:36:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TtVuCCSW5sdeckRF5RQBKHNtaTNY4BW0Eo2LYHyO0/DA2uUitrYNkc5XPVCnAZ3j0E
         5FFYyxz86j5R2Rlcli6TXkku+mvIRRbCuzORZv//YUzBVe9xPF0nBfXu5GdgY3GAJKBW
         kZ9glU5KIqWhfd4d1yHdlqJndu/jZZii+T8ro=
MIME-Version: 1.0
In-Reply-To: <20100510153111.GA28889@fujitsu>
References: <1273484217-4073-1-git-send-email-reodge@gmail.com>
	 <20100510153111.GA28889@fujitsu>
Date: Tue, 11 May 2010 08:36:18 +0800
Message-ID: <AANLkTikab-UamrSjFAyaBNnY6ySIDoaeWYpN9rlfNRPg@mail.gmail.com>
Subject: Re: [PATCH] Staging: comedi: Fix long line lengths in comedi_fops.c
From: Mark Rankilor <reodge@gmail.com>
To: =?ISO-8859-1?Q?Charles_Cl=E9ment?= <caratorn@gmail.com>
Cc: gregkh@suse.de, shawn.bohrer@gmail.com, fmhess@users.sourceforge.net,
       andrea.gelmini@gelma.net, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/10 Charles Clément <caratorn@gmail.com>:
> I think it'd be better to keep the opening parenthesis on the same line
> of the function and maybe the first argument, too.

Charles, I agree with you here. I did it this way since there is a
very similar line in the code paragraph above it, so I figured I'd
stay consistent.

I'll revisit this and change both of them to be in the style you suggested.

Cheers,
Mark
