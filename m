Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab0GWJR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 05:17:28 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45247 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab0GWJR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 05:17:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lLt2qXUhajMqDDY70rNi9vDNWla5a3gqeZ2eC7BF76sqZgroLSzBInfd4A/nIFxDns
         zc41CBO9Tr0z2NBnCsBLLa4F+nnfcKL30/pTTB9G2eXsmJIL+jqPk03WE2r0Xa+K/z9d
         4p2KdYhDqYmOJ+ZBCqHW4gXkkfyAFROrhaqIA=
MIME-Version: 1.0
In-Reply-To: <4C495880.2090705@gmail.com>
References: <1279865467-16522-1-git-send-email-emjay1988@gmail.com>
	<4C495880.2090705@gmail.com>
Date: Fri, 23 Jul 2010 19:17:21 +1000
Message-ID: <AANLkTi=KTEtA57aTHEd_tzXAmK_WsX+P4jO_3TedFGFk@mail.gmail.com>
Subject: Re: [PATCH] Staging: comedi: comedidev: Fixed a macro definition code 
	style issue
From: Michael Jensen <emjay1988@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 6:53 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>
<snip>
> Hmm, does this compile?
>
> --
> js

I did build the comedi directory (as per Greg's "Write and submit your
first kernel patch" video), and didn't get any errors (once I'd done
the configuration)...

Did I miss something?

[apologies, resending because gmail sent HTML versions to the mailing
lists (ack!)]

--
Regards,

Michael Jensen
