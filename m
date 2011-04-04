Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab1DDPtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 11:49:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50608 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab1DDPtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:49:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=J3YtlvW0LLmFd7J7MciuPFEUJCkSX81Caus+U7ckmrlzlCFV7uKuL7awDtFPpodM9q
         kZRCNqHvTLr5LAEprfKTY3EFyUlf0bK9aJ8z7A2M5+2c2P5JQ6XA6cm6vEzIBrWETf9x
         eOEpqu5VeKuBXE6TzEEn4foBN6AAfQm61dlow=
Subject: Re: [PATCH 2/2] kbuild: move KALLSYMS_EXTRA_PASS from Kconfig to
 Makefile
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Valdis.Kletnieks@vt.edu
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paulo Marques <pmarques@grupopie.com>
In-Reply-To: <131611.1301921158@localhost>
References: <1301913651-9055-1-git-send-email-dedekind1@gmail.com>
	 <1301913651-9055-2-git-send-email-dedekind1@gmail.com>
	 <131611.1301921158@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 18:47:12 +0300
Message-ID: <1301932032.2760.103.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 08:45 -0400, Valdis.Kletnieks@vt.edu wrote:
> If the Makefile has enough information to print the warning, why can't it go
> ahead and do the extra pass itself instead of issuing the warning?

Actually I need to dig and check if make can really always spot all
errors.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

