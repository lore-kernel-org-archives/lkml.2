Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab0KXTp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:45:28 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59202 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab0KXTp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:45:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=riUiaMGz1A84zaeITkXjEpvkZpxAOjukbl68xeDW1jFNluFcvcUvMFRUa9DLnoPXFd
         mleTjgeiWerTEmvotECLnY7qi8+n3qGLmhVa6dSQIsOygKuC1p+CBnn51ERSlCq/ApZi
         +etIxS4PJvT6ctt8rJHHOpfhlFc7P1z2vXBAo=
Message-ID: <4CED6B53.50408@suse.cz>
Date: Wed, 24 Nov 2010 20:45:23 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Sergey Lapin <slapin@ossfans.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: ldisc problems with 2.6.32-2.6.37-rc2 (at least)
References: <20101124135249.GA7282@build.ihdev.net> <4CED2251.3020708@suse.cz> <20101124170326.GB7282@build.ihdev.net> <4CED6ACF.9000402@suse.cz>
In-Reply-To: <4CED6ACF.9000402@suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 08:43 PM, Jiri Slaby wrote:
> Could you provide disassembly of tty_set_ldisc? E.g. by extracting it from:
> objdump -d drivers/tty/tty_ldisc.o

Or maybe better after linking:
objdump -d vmlinux

thanks,
-- 
js
suse labs
