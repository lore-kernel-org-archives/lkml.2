Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab0GTIB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 04:01:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56498 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab0GTIBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 04:01:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=pYWRPfHNSY6Q3O7uAz6FFpL1tsbqWKdC4ggBg/UmHCB7jmyicBUhC1rydNxbPk2YQn
         3hl4JrLoqOWkZFlvqHhoYZhdgmE3q0alXVvgVNAMwbN/kH8e72AMPMdirR5yzqWlhVVQ
         DZHvV0HqVEBK3jlk2Fmt1uPqMuAixRqkqccNo=
Message-ID: <4C4557EE.2090708@gmail.com>
Date: Tue, 20 Jul 2010 10:01:50 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: manual merge of the limits tree with the tile tree
References: <20100720134833.4082eed4.sfr@canb.auug.org.au> <4C452399.3050708@tilera.com>
In-Reply-To: <4C452399.3050708@tilera.com>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2010 06:18 AM, Chris Metcalf wrote:
> Jiri, would it be possible to put __NR_prlimit64 as number 261 in
> <asm-generic/syscall.h>?

Hi, I assume you meant asm-generic/unistd.h. Yes, I will do that.

thank you both,
-- 
js
