Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab0JSJkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:40:42 -0400
Received: from web37608.mail.mud.yahoo.com ([209.191.87.91]:21826 "HELO
	web37608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757848Ab0JSJkl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:40:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=IijIDHAhhPotIiiYT1C7a89xUxyHJsZwlBc1gODeMQ2f5TpdXvwXPKB3+d5CGfacHt4ZdoK2fJEIAIKevlF/9MOmSxC62aOPJZ2LSZbwRM/Y/eIo74Mg+dWyMM4resqfMD37jT/NAY9KyCXfkDBo7oTCv1c7opoRihECBeS1N2Y=;
Message-ID: <767911.16428.qm@web37608.mail.mud.yahoo.com>
X-YMail-OSG: UeDtV8sVM1nKshQ8R.4qfcOTi1pA8X9ZUBgOmU3GAWNEWqK
 XL0PddtuAnqTF8zsyCWfXS_eD.km6td1b9RQ6JqIPHLL9jRV2yNBFYXaeShj
 TRnN9AYKHASHlmf8ZBP_u1WC6P8RHf3FfE79kwvGoi7x2vWCk.V8ShXWpKwB
 6ZV5AVPV58gow0IVNz68frW7jWT9.WqJWKC9KWGLn.dRWIEcqUFzZ75LLjC4
 Wvq0o5aFK_Z.kOF_WJuaO8DlWJSiQ_i.cQ2dgA2vEyZ372fyNjyYAcGSuHKm
 tFe_S9tLPsdFnfT0v..aBqwLYktebRB.hVGHwPZBQdMMW1MXz3q46O6nheVa
 i
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.106.282862
Date: Tue, 19 Oct 2010 02:40:39 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 0/6] Results of my work on memorystick subsystem
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1287410779.20229.9.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 18/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> 
> But for mspro driver, it would be really hard for me to
> split it.
> I have rewritten a lot of code there.
> Can't we just review the end result instead of the patch?
> 
> To split the patches, I pretty much need to rewrite the
> whole thing once
> gain.
> I don't want to do that.
> 

First, a useful citation (Documentation/HOWTO:548):
"The Linux kernel community does not gladly accept large chunks of code
dropped on it all at once.  The changes need to be properly introduced,
discussed, and broken up into tiny, individual portions."

I actually attempted to submit a large "full rewrite" patch early on
during development of one of my drivers. I was a sole developer and it was
not even on a stable tree, as far as I can remember. Yet, that patch was
dropped immediately with the above given reason.

And yes, I had to rewrite the whole thing again, this time in small steps.



      
