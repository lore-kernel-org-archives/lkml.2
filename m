Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab0INXS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 19:18:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45390 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab0INXS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 19:18:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ENf1GwCPgTzULrrTs8OOqwPmu8+/sE7brxr0O9keZ/vA2AHPNi/Ult5jzOryliLMzJ
         TlF8u2FpXHuRR/gIFdJttlKLPiw2mGvzC2+nC3wj+rWSdQN58iWRHpldDmW57Pwg72Ty
         CPqr2qEoW/gqwimnfyadZ1CwLkhI9U+NRetLg=
MIME-Version: 1.0
In-Reply-To: <1284115245-23876-1-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1284115245-23876-1-git-send-email-ext-phil.2.carmody@nokia.com>
Date: Tue, 14 Sep 2010 16:18:55 -0700
X-Google-Sender-Auth: vBYG9p_aem24Z1GrPkfcxM7bIu0
Message-ID: <AANLkTi=RsA0tACWOg+8RTSuDHwa4LGOiyO-4TxpJ_rb5@mail.gmail.com>
Subject: Re: [PATCH 0/2] ia64: possible module unwind table optimisation
From: Tony Luck <tony.luck@intel.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: fenghua.yu@intel.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 3:40 AM, Phil Carmody
<ext-phil.2.carmody@nokia.com> wrote:
> Alas I have no way to test this patch.

Phil,

I have this built and booted on an ia64 ... what do you want me to measure? The
number of iterations in:

  for (table = unw.tables; table; table = table->next)

before we find the right table to look?

-Tony
