Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2JOLp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 07:45:58 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63042 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2JOLp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 07:45:56 -0400
MIME-Version: 1.0
Date: Mon, 15 Oct 2012 13:45:56 +0200
X-Google-Sender-Auth: ATRg41ZVZpMqsxAERANO8ebuBM0
Message-ID: <CAE7jHC9UuokkM9EqkuO0Z-NZ4MTb49LdinZGpXZ+Vt+5D7fiHg@mail.gmail.com>
Subject: question about configfs_attribute
From: Constantine Shulyupin <const@makelinux.com>
To: jlbec@evilplan.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I wonder why show and store methods are not stored inside of
configfs_attribute but stored in wrapper struct defined with
CONFIGFS_ATTR_STRUCT ?

Thanks

-- 
Constantine Shulyupin
http://www.MakeLinux.com/
Embedded Linux Systems,
Device Drivers, TI DaVinci
