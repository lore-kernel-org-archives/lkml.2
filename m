Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab0ELWdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 18:33:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758368Ab0ELWdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 18:33:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DO3niFY/I72qJCJe02AojGiiDWqSYoMrzHTDduJzzhwSq24Xh40O6OvM34/ssLSBlR
         +sHJV2Rf4ixdazJtHjQvtFKqY/6Hg8pW5fEU95FA5zDiWKiVkph+wxfVrWhBY/9HvX2E
         H04tn50BAqfgZzcmLUDM8pHNOiVNVaR7oPiC0=
Subject: Re: [pm] resume from s3 oops? (last checked on rc6)
From: "=?gb2312?Q?=B1=F6=CE=F7=C3=C9?=" <binximeng@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: BinXimeng@gmail.com
In-Reply-To: <1273672772.7284.32.camel@eee51>
References: <1273672772.7284.32.camel@eee51>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 00:32:10 +0200
Message-ID: <1273703530.3375.1.camel@xli51>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the follow-up.
Doesn't work with rc7 either. Tried the pm_tests, they all pass.
pm_trace only shows the following hash match

hash matches drivers/base/power/main.c:564

probably no use?

