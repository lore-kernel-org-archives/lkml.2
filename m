Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab1CCUu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:50:26 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:45360 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758803Ab1CCUuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:50:21 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] st_nlink after rmdir() and rename()
References: <20110303032454.GI22723@ZenIV.linux.org.uk>
	<AANLkTin5GpLSvNnLb_=2wMS9w6RjHa=q8p0gOENtNjfq@mail.gmail.com>
	<20110303060352.GK22723@ZenIV.linux.org.uk>
	<AANLkTi=85DJo-Qy0bABKg1J_j0s=8HfTt1m+rq4E5GqS@mail.gmail.com>
	<87tyfk7x0c.fsf@devron.myhome.or.jp>
Date: Fri, 04 Mar 2011 05:50:19 +0900
In-Reply-To: <87tyfk7x0c.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Fri, 04 Mar 2011 05:46:27 +0900")
Message-ID: <87pqq87wtw.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

> (IIRC, it's checking i_nlink == 2, to know empty dir or not).

Ah, the check would be it doesn't have sub dirs actually.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
