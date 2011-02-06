Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab1BFPRQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 10:17:16 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35841 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab1BFPRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 10:17:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=j+RMlfItM4O43prjeMnVh528gH2Y1gOKarxsinOcXFC9OoPw7HgD6Tq+5F0Fktd64V
         Vq9rIx0cUam78NUJ8pBeDulsdk6hrfUb6GqqXi5v2iuvu6Vm7coQLZiQgyxvl4gChOcq
         JxoeaQ/qBv4ZQbuZNbBuFp4fpySoIUxqTFtto=
Subject: Re: [PATCH 20/20] fs: ubifs: world-writable debugfs dump_* files
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Adrian Hunter <adrian.hunter@nokia.com>, linux-mtd@lists.infradead.org
In-Reply-To: <cd575609cc07581a71ba925308d9d69c6e0c6d79.1296818921.git.segoon@openwall.com>
References: <cover.1296818921.git.segoon@openwall.com>
	 <cd575609cc07581a71ba925308d9d69c6e0c6d79.1296818921.git.segoon@openwall.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Feb 2011 17:16:19 +0200
Message-ID: <1297005379.4460.34.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-04 at 15:24 +0300, Vasiliy Kulikov wrote:
> Don't allow everybody to dump sensitive information about filesystems.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Good catch, thanks. I'll push this patch to the ubifs-2.6.git tree,
thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

