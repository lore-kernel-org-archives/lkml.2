Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab3AIQJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:09:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:63772 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857Ab3AIQJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:09:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: James Hogan <james.hogan@imgtec.com>
Subject: Re: [RFC PATCH v1 24/40] metag: DMA
Date: Wed, 9 Jan 2013 16:08:59 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1351700061-7203-1-git-send-email-james.hogan@imgtec.com> <201211231647.27260.arnd@arndb.de> <50ED9525.9040806@imgtec.com>
In-Reply-To: <50ED9525.9040806@imgtec.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301091609.00146.arnd@arndb.de>
X-Provags-ID: V02:K0:wUZb0pLtVuHjCaUsHnHiRJa1cQ52clMLR92VYRa0QZg
 aqSBPhjTD5+jVb0sysEN0UqwQy2BQ5XoKQI8MUwbKChuRC7cyA
 dU9mRXzXFwxpUePdWa2l1+RqJY+Bhk1m8rrzMxaf8ejI4SHI2d
 fEbMi6CWCIX08IYzb9bDAKliOLhy3MktEPpGiC6g36hIPrGJ8u
 TRJLkAibZRJ0BKiPci+/S67PvboLwxcdN3BHpn2CEl5ApklLop
 2vllzHqIuUuCoN/jCqwgWldVUSUkne03+zlk4e2JkmE77Srl8g
 n8SCEfKCAAhc6Bt+rV5aiA66ugA279JeLznWee4g0aCC2Vyxa9
 AP2QnOLJ2iBiPr7KCzn8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2013, James Hogan wrote:
> Would you like me to include this in the meta patchset or is it okay for
> you to take it through the asm-generic tree? (I can resend separately if
> you like)

I usually prefer patches to go through the tree of whoever needs them
for asm-generic.

	Arnd
