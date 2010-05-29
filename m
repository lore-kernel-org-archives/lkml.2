Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab0E2Nn0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 09:43:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52280 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629Ab0E2NnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 09:43:22 -0400
Date: Sat, 29 May 2010 15:43:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] fs: optimize mpage_bio_submit()
Message-ID: <20100529134317.GB28370@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Changli Gao <xiaosuo@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1275095966-18382-1-git-send-email-xiaosuo@gmail.com>
 <20100529124735.GB25092@liondog.tnic>
 <AANLkTinwjNpAg6y3n1ZzAtPIv-sJE_P7WjbzzrRRCBVD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTinwjNpAg6y3n1ZzAtPIv-sJE_P7WjbzzrRRCBVD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Changli Gao <xiaosuo@gmail.com>
Date: Sat, May 29, 2010 at 09:33:02PM +0800

> Compiler is smarter than I thought.

Not as much as we would like to though :)

-- 
Regards/Gruss,
    Boris.
