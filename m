Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab1DLESI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 00:18:08 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:36575 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab1DLESF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 00:18:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=U6O/mmtwvTCVruUmpCZFSDc1qmfc/v3/TK1IazDmWPYbjR1B8bg7nee8+18SrSsf4A
         aIt5AxgKflsK8AiGNFIoTJVgzRnmOo2EVaqxi3tR/50Srz2OM3o7a9hUO9BQWpXUU1Gp
         MbvJYvGzOGzVYDbUIzOBjxTJXF2ff5IemHYOM=
MIME-Version: 1.0
Date: Mon, 11 Apr 2011 23:18:04 -0500
Message-ID: <BANLkTinNm_j_SpjTXKVPXkWFmyjBZAQWyQ@mail.gmail.com>
Subject: undefined reference to `sparse_keymap_free'
From: Steve French <smfrench@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-rc3 build error:

drivers/built-in.o: In function `msi_laptop_input_destroy':
msi-laptop.c:(.text+0x1a3be1): undefined reference to `sparse_keymap_free'
drivers/built-in.o: In function `msi_send_touchpad_key':
msi-laptop.c:(.text+0x1a3c45): undefined reference to
`sparse_keymap_report_event'
drivers/built-in.o: In function `msi_init':
msi-laptop.c:(.init.text+0xe055): undefined reference to `sparse_keymap_setup'
msi-laptop.c:(.init.text+0xe07d): undefined reference to `sparse_keymap_free'


-- 
Thanks,

Steve
