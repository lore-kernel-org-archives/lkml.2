Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab1ELN5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:57:12 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53650 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab1ELN5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:57:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Cv2hNssMzIMJsFZpKSb4XbZnEYTTXDlDRB4y40jdHRbRzw4S0t05li6jlzHWijmCMa
         pjZjNQqOBqCIIwEzGl8Q3+aOJ2F38F+Yfm82QRnxzSm4sGAkLAwgIsEpY8YeVJOLL5Y2
         btSieYwS7a2/j0tQNTzyk1vGklp2Oq9DCQAjQ=
Subject: Re: Bug in MTD NAND ONFI chipsize detection
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Nitin Garg <nitingarg98@gmail.com>
Cc: Matthieu CASTET <matthieu.castet@parrot.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1305208380.14423.10.camel@localhost>
References: <BANLkTi=e1mUTX4X7ui+HVCGh=sZ=HLoNCw@mail.gmail.com>
	 <20110511183322.da0739c9.akpm@linux-foundation.org>
	 <BANLkTikrqzpU8qZ5FUgG4HaBgZAvmbOHrQ@mail.gmail.com>
	 <BANLkTinGFDHj4s6nAXMiq8dYW_UO6W+YXg@mail.gmail.com>
	 <BANLkTin5X7d+_b5+7N5g941bz12jc+zMZA@mail.gmail.com>
	 <4DCB908C.80505@parrot.com>
	 <BANLkTik37R8tSxc9_qmBT5a2m9mAA_2XKQ@mail.gmail.com>
	 <1305208380.14423.10.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 16:53:46 +0300
Message-ID: <1305208426.14423.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 16:53 +0300, Artem Bityutskiy wrote:
> which problem the bug fixes, and make sure the commit message is

Sorry, s/the bug fixes/the patch fixes/

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

