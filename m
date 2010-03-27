Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab0C0TCg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 15:02:36 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:43043 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab0C0TCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 15:02:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=GOAErerOtd5gYKGRuVADITkFxqs3tjNtz78nyazutLterW75GAG8MfLXoiwAQ4nG9J
         Qb4kZ8ckorWbsaP2129WbY/Fta+B8TvXgwT6VwhwNY4JOgUsKs9/fi6+O4/6l5ZdD9C8
         ccYdvb2na/Adu6ddYYtlvcw3D8zc2hOZgf410=
MIME-Version: 1.0
Date: Sat, 27 Mar 2010 20:02:34 +0100
Message-ID: <9c2470ce1003271202h65588454t995f204f60995e77@mail.gmail.com>
Subject: =?windows-1252?Q?2=2E6=2E34=2Drc2=2Dgit3_=2D_missing_patch_=2D_include=2Flinux=2Fpktc?=
	=?windows-1252?Q?dvd=2Eh=3A166=3A_error=3A_field_=91read=5Fqueue=92_has_incomplete_type?=
From: Jan III Sobieski <jan3sobi3ski@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch is missing http://lkml.org/lkml/2010/2/25/425

  CC      fs/compat_ioctl.o
In file included from fs/compat_ioctl.c:105:
include/linux/pktcdvd.h:166: error: field ‘read_queue’ has incomplete type
include/linux/pktcdvd.h:167: error: field ‘write_queue’ has incomplete type
include/linux/pktcdvd.h:207: error: field ‘orig_bios’ has incomplete type

-- 
Jan III Sobieski
