Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab1DDMtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 08:49:45 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37199 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab1DDMtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 08:49:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vPonb8vsCqEJzktzViJkeOHqDCRIWxE7hrq1WBa5IRGexVmG2L7I/l5Sd6asEa7fgv
         c3QdajXm+UqqaQjzSQxMd5MLaH8vQMXLZXZsxL82RI0keWAlZjt6xzM/uMvAMY39Sx/9
         33ac9hARMiBticu9sXfK9cUtT3pY3lgExGkGk=
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
Date: Mon, 04 Apr 2011 15:47:10 +0300
Message-ID: <1301921230.2760.79.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 08:45 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 04 Apr 2011 13:40:51 +0300, Artem Bityutskiy said:
> 
> > 3. By default KALLSYMS_EXTRA_PASS is disabled and if kallsyms has issues,
> >    "make" should print a warning and suggest using KALLSYMS_EXTRA_PASS
> 
> If the Makefile has enough information to print the warning, why can't it go
> ahead and do the extra pass itself instead of issuing the warning?
> 
> (I'm obviously missing something here, as I'm foolishly posting to lkml before
> caffeine ;)

Good question, I thought to force people to send a bugreport.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

