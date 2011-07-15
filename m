Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab1GOU6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 16:58:05 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:40917 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1GOU6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 16:58:04 -0400
Message-ID: <4E20A9D8.6080907@gmail.com>
Date: Fri, 15 Jul 2011 22:58:00 +0200
From: =?UTF-8?B?TWlsYW4gUGzFvsOtaw==?= <milan.plzik@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110619 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Dysfunctional zcache in 3.0rc7 (Re: zcache: rename zcache.c to avoid
 build problem)
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  in linux-3.0rc7 (and possibly others), zcache doesn't build correctly
-- zcache.o is omitted from linking. This results in kernel containing
tmem.o, but not zcache.o and no zcache functionality.

  This issue (and also a patch) was previously mentioned at
https://patchwork.kernel.org/patch/903912/ , however no action was taken
up to now, and 3.0 release is really close. Patch mentioned above makes
zcache work properly.

  Regards,
    Milan Plzik
