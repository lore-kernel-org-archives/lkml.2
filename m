Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab1HWIrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 04:47:43 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33113 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab1HWIrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 04:47:42 -0400
MIME-Version: 1.0
Date: Tue, 23 Aug 2011 10:47:41 +0200
Message-ID: <CAC9WiBiVj7GSAE4WcJ5peniP1a53Cgmmjd=ZHjjqSMBT5EsXaA@mail.gmail.com>
Subject: make silentoldconfig question
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: mmarek@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm a bit confused about silentoldconfig target since it doesn't
really makes any differences with oldconfig.

The only difference I found is this one: if I add a new valid symbol
at the end of my .config (therefore the position of the symbol is
incorrect) then olconfig will recreate the .config and thus print its
annoying message "# config written ..." to stdin whereas
silentoldconfig won't print anything not because it's silent but
beacuse the .config is not recreated so the symbol is still badly
located at the end of the file.

Could anybody enlighten me please ?
-- 
Francis
