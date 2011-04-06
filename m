Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab1DFJG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 05:06:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60873 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab1DFJG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 05:06:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fJKSPNnCgP9cBfz4HyaJ8JojYf83wRz1BlnvrjmTeAwengs24vYtSMiWe7AxIWC0Dh
         s/fpRLkWwXr0o5vIFROr+FR3DMn+dKM4olV73dUn+cXWRXgsKP5A8Q6u3Xz17eRVlEgz
         i82VMuhxVmauA5DYvAzjeAQSFJconnjoeuKJc=
Subject: Re: [PATCH 00/34] Make kernel build deterministic
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110406085712.GA16597@elte.hu>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
	 <20110405154918.GA31337@suse.de> <1302031447.2608.41.camel@koala>
	 <20110406085712.GA16597@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 12:04:13 +0300
Message-ID: <1302080653.2742.32.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Removed CCs to spam people less]

On Wed, 2011-04-06 at 10:57 +0200, Ingo Molnar wrote:
>   checkpatch: Warn about usage of __DATE__, __TIME__ and __TIMESTAMP__

Great, thanks, did not see this!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

