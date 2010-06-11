Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760453Ab0FKTQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 15:16:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35284 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab0FKTQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 15:16:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=U7+i70iIKfRT6SMqElBeh/yldN55umhjUYNIJGy1/vhAE2ChWoha25J0U6t6GaCnDj
         QG3pLgcevYT9aGFcQyiTxb/oIJybGQzg515z76ifd8Nu9EI2Fs8qzh5U/8OeRf2btWUw
         IYSrxjKS18F727Rt99hg2QaUUZmkl5YH1bSTM=
Subject: Re: [PATCH] Fix the outstanding issue with hangs on insert/removal
 of mmc cards
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-mmc <linux-mmc@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Philip Langdale <philipl@overt.org>
In-Reply-To: <1276282801.8557.20.camel@maxim-laptop>
References: <1276282801.8557.20.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Jun 2010 22:16:31 +0300
Message-ID: <1276283791.8557.29.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, forgot one hunk...
Will reply with the patch.

Best regards,
Maxim Levitsky

