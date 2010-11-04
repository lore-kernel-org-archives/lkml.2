Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab0KDWC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 18:02:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34809 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab0KDWC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 18:02:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=QouqBG3tVijQBmceXSCnHhRyo38zFnev6Tp8R8fLRF4hDTvYVzh5cbqogvfbxwCCl0
         dqbael4o4hCfV9IXTP9Nx4eWffp4NJLFyXMpIUn2cu9Qw2IkUxwDubW5nJzU3C3RVSyD
         voHRk8aHoPiKKr4NE7WXsG6Jct58SiLRF0H3M=
Message-ID: <4CD32D8B.2080709@gmail.com>
Date: Thu, 04 Nov 2010 23:02:51 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        werner@suse.de, alan@lxorguk.ukuu.org.uk, gregkh@suse.de,
        linux-kernel@vger.kernel.org, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org
Subject: Re: [PATCH v2 2/5] parisc: cleanup console handling
References: <1288884024-23873-1-git-send-email-jslaby@suse.cz> <1288884024-23873-2-git-send-email-jslaby@suse.cz> <20101104172613.GK8332@bombadil.infradead.org>
In-Reply-To: <20101104172613.GK8332@bombadil.infradead.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2010 06:26 PM, Kyle McMartin wrote:
> On Thu, Nov 04, 2010 at 04:20:21PM +0100, Jiri Slaby wrote:
>> * use newly added for_each_console for iterating consoles
>> * add proper console locking
>> * do not initialize tmp twice
>> * no need to declare console_drivers, it's already done in console.h
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> Cc: Kyle McMartin <kyle@mcmartin.ca>
>> Cc: Helge Deller <deller@gmx.de>
>> Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
>> Cc: linux-parisc@vger.kernel.org
> 
> This looks fine...
> Acked-by: Kyle McMartin <kyle@mcmartin.ca>
> 
> I assume that since it depends on 1/5 you'd prefer to merge it with the
> rest?

Yeah, I would like to, with ACKs from relevant people.

thanks,
-- 
js
