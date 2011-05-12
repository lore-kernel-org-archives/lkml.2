Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab1ELN4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:56:40 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53650 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab1ELN4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:56:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AdJValLJodYDzxvNiANAMHmooFhKtRZudSWj9F0TG/JP7NU5eDDUtfS4FHsOJHtlbi
         4bAeerPLbBkJt8VTeB7MdU6tjqbRA8xiQYzj858O4rx5Qsn54K9F6ktLKSMKHqdOYvnY
         K+qSFW65EjkzQiHoxCTzOVF53/2mRE+bv5Tdc=
Subject: Re: Bug in MTD NAND ONFI chipsize detection
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Nitin Garg <nitingarg98@gmail.com>
Cc: Matthieu CASTET <matthieu.castet@parrot.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTik37R8tSxc9_qmBT5a2m9mAA_2XKQ@mail.gmail.com>
References: <BANLkTi=e1mUTX4X7ui+HVCGh=sZ=HLoNCw@mail.gmail.com>
	 <20110511183322.da0739c9.akpm@linux-foundation.org>
	 <BANLkTikrqzpU8qZ5FUgG4HaBgZAvmbOHrQ@mail.gmail.com>
	 <BANLkTinGFDHj4s6nAXMiq8dYW_UO6W+YXg@mail.gmail.com>
	 <BANLkTin5X7d+_b5+7N5g941bz12jc+zMZA@mail.gmail.com>
	 <4DCB908C.80505@parrot.com>
	 <BANLkTik37R8tSxc9_qmBT5a2m9mAA_2XKQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 16:53:00 +0300
Message-ID: <1305208380.14423.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 07:34 -0500, Nitin Garg wrote:
> I do not see any diff for mtd.

Please, send a patch with a better commit message clearly explaining
which problem the bug fixes, and make sure the commit message is
understandable even by people who have not read the ONFI standard.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

