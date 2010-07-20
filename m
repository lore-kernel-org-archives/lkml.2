Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab0GTIIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 04:08:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54768 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab0GTIIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 04:08:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nFOXbmjZ1veZ1l1OLJBmbBoRoKWR6JKuuV65Boya+WMYNRmP10P7o7HW/l6vBJmIte
         sO4Ez+InlffON7C2m/YzPiuj+5+pGqa2QI9xh/tt0tuzRgI+0rTpS+/jOPOKoOOAOKTd
         KO089ZC8IKQp6hKUgpmXEDr4pmK9q+AnzfUlg=
Message-ID: <4C455982.1000800@gmail.com>
Date: Tue, 20 Jul 2010 10:08:34 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: writable limits into -next
References: <4C448344.9020807@gmail.com> <20100720110814.ffe72bc0.sfr@canb.auug.org.au>
In-Reply-To: <20100720110814.ffe72bc0.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2010 03:08 AM, Stephen Rothwell wrote:
>> There will be merge conflicts in unistd files with "unistd: add
>> __NR_prlimit64 syscall numbers". You can take a look at
>> http://decibel.fi.muni.cz/cgi-bin/gitweb.cgi?p=mm.git;a=shortlog;h=refs/heads/devel
>> to see how it looks like in -next.
> 
> Not sure how this is useful as it is your mm tree?

Hi, feel free to ignore it. It was intended just as a hint how the
conflicts may be resolved.

thanks,
-- 
js
