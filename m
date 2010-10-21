Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab0JUHeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 03:34:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43978 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab0JUHeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 03:34:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=d0iYAcQObeaSKc8pzJF5PDwSEIgEAVUddYJQpB7RLb6RH2lqeUEKKad0UmAwCWST3A
         vO+Ls77MPUMiJfnJBEH3YnuO2pHiS5Rp03a/fLdTCNDnUPtrh7D8AqH3T08Gp8P18hiV
         ew9mD1Wv7Vcs70cu3vLj7WfTOYldWB4POtlIU=
Message-ID: <4CBFECF6.8040304@gmail.com>
Date: Thu, 21 Oct 2010 09:34:14 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: ptrace BUG [was: mmotm 2010-10-13-17-13 uploaded]
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org>	 <4CBF0FB7.3000602@gmail.com> <20101020155406.GC5387@nowhere>	 <4CBF12D4.4070207@gmail.com> <1287591225.3488.29.camel@twins>
In-Reply-To: <1287591225.3488.29.camel@twins>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2010 06:13 PM, Peter Zijlstra wrote:
> On Wed, 2010-10-20 at 18:03 +0200, Jiri Slaby wrote:
>> I applied the patch and got another BUG:
> 
> I don't think it applies on its own.. please use -tip or -next.

Ok, it works in mmotm 2010-10-20-15-01.

thanks,
-- 
js
