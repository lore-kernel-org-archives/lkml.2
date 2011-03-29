Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab1C2OdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:33:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34374 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab1C2OdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:33:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=tIJktM5AjD7emnJu+VFmMsyE1yCJFvxUxuqtdBuTs/2tTHqGDaXP2Rh/AzeXyLLVdf
         rKU0AUsftAddVFT5yXcczAtV/54TjFnYAADKhsvl/xLcPKaC93MvVF8ifhdHx/o38rRy
         WycBqGHe4aHnlJ73i0Gh54lamoJ3KbZQ8HEow=
Message-ID: <4D91ED6B.5020100@gmail.com>
Date: Tue, 29 Mar 2011 16:32:11 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Roland Dreier <roland@purestorage.com>
CC: Klaus Dittrich <kladit@arcor.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.37.6 2.6.38.2 tst-aio4.c
References: <4D90CDDE.1020500@df1tl.local.here> <AANLkTikzU=zNrjs=mnLnxm3SUBAyVpWF5UmkJvXFnF-G@mail.gmail.com>
In-Reply-To: <AANLkTikzU=zNrjs=mnLnxm3SUBAyVpWF5UmkJvXFnF-G@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2011 08:14 PM, Roland Dreier wrote:
> On Mon, Mar 28, 2011 at 11:05 AM, Klaus Dittrich <kladit@arcor.de> wrote:
>> Reverting the patch of kernel/signal.c which was
>> applied to 2.6.37.6 and  2.6.38.2 solved the problem.
> 
> Indeed, I found that the same patch was to blame.  Fix coming shortly.

Is there a patch for this already?

thanks,
-- 
js
