Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab0E1Fuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 01:50:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41448 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0E1Fut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 01:50:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rjZSzA06rKGMv8sD9LpFwnAEXbMdGT8CGc8XBbAqKj1vcBlFopKo1hjAjuWFzUXETO
         iP+Il8B6qXTDPZKDEYOFBRMvQSAdVx586HCBC6XRORx99cnoM0PZdsZYzlxLB4P/VzDx
         6dvARIg0EI3yTzDYfw3aTgI8lS9wQ/uSKXzV8=
Message-ID: <4BFF59B5.70002@gmail.com>
Date: Fri, 28 May 2010 07:50:45 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100522 SUSE/3.1rc1-2.1 Thunderbird/3.1
MIME-Version: 1.0
To: JD <jd1008@gmail.com>
CC: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: udevd high cpu hogging in kernel-2.6.34   git8 to git-13
References: <4BFF565C.3080108@gmail.com>
In-Reply-To: <4BFF565C.3080108@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2010 07:36 AM, JD wrote:
> I noticed that since git8, udevd consumes from 50 to 80 percent of cpu.
> The main udevd thread is niced to -4, and 6 or more child threads are
> niced -2.
> 
> So, I backpedaled to git7, which does not have this "feature" :)

Is it this one again?
http://lkml.org/lkml/2010/5/22/150

Could you try to revert the patch?

-- 
js
