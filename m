Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab0EGJFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 05:05:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:33405 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab0EGJFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 05:05:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=GtYHOgg8TNpScyEuI1mmGc9WNTThWoYOhm5ulY3VhGIqEZJXClH3a8NNX7tmtcuRi1
         I7g56J1DVhXvdl1np5Xuvj/jQHo7gSBuXsCOpredtaEhdu5O5NJu8DBPub9Wr82Wl2MZ
         I8H9avuFK+b45Ia21z4D8y736HmA6Hyc4/KFI=
Message-ID: <4BE3D7D9.2080406@gmail.com>
Date: Fri, 07 May 2010 11:05:29 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.5pre) Gecko/20100430 SUSE/3.1b2-7.1 Thunderbird/3.1b2
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       adobriyan@gmail.com, nhorman@tuxdriver.com, oleg@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 09/11] rlimits: switch more rlimit syscalls to do_prlimit
References: <1273222543-17083-9-git-send-email-jslaby@suse.cz> <1273222977-17419-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1273222977-17419-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2010 11:02 AM, Jiri Slaby wrote:
> From: Jiri Slaby <jirislaby@gmail.com>
> 
> This is the correct one, I forgot to re-run format-patch.

Ah, no I didn't. There are two 09/11 because it generates the latter
with a different name.

So "rlimits: switch getrlimit to do_prlimit" is old and wrong.

-- 
js
