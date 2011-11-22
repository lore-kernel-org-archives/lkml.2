Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab1KVPBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:01:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44077 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab1KVPBP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:01:15 -0500
MIME-Version: 1.0
In-Reply-To: <1321952446-7591-2-git-send-email-jj_ding@emc.com.tw>
References: <1321952446-7591-1-git-send-email-jj_ding@emc.com.tw> <1321952446-7591-2-git-send-email-jj_ding@emc.com.tw>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 22 Nov 2011 10:00:50 -0500
X-Google-Sender-Auth: EXtGCbuVzxoR-yGj-PY-S1KyyZc
Message-ID: <CAMjpGUdn-Rp+7Qo_zJOoG9-QtuF-r=rPKODm_ktyjObR-_OhAg@mail.gmail.com>
Subject: Re: [PATCH TRIVIAL 1/5] Input: keyboard: use macro module_platform_driver()
To: JJ Ding <jj_ding@emc.com.tw>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, JJ Ding <dgdunix@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 04:00, JJ Ding wrote:
>  drivers/input/keyboard/adp5520-keys.c       |   13 +------------
>  drivers/input/keyboard/bf54x-keys.c         |   14 +-------------

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
