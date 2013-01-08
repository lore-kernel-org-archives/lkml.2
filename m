Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab3AHKYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 05:24:20 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:57365 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab3AHKYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:24:18 -0500
Message-ID: <50EBF402.5070007@gmail.com>
Date: Tue, 08 Jan 2013 18:25:06 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "lin >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: [Consult] our latest kernel and latest Android  under arm Samsung
 S5PV210 with yaffs2 file system
Content-Type: multipart/mixed;
 boundary="------------010006000403060605000203"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010006000403060605000203
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit

Hello all:

Consult:
  whether the latest kernel can update the latest android OS ?
    it is android 4.0 (kernel-3.0.8)
    under arm Samsung S5PV210 with yaffs2 file system

Background:
  development board:
    the core hardware is Samsung S5PV210
    the extended vendor is FriendlyARM (a Chinese vendor)
    use yaffs2 file system for android
      it seems yaffs2 is a standard file system for android.
        for my android HTC phone is also yaffs2 file system.
  finished:
    for the android kernel its own
      can compile from the source code successfully.
      can update to the development board successfully.
      only need zImages, not need additional modules.
        can start android without any files under /system/lib/modules/*
  current:
    I am trying to use our latest kernel (such as next-20130104)
      can compile from the source code successfully.
      it has no source code for yaffs2 file system.
      not know whether can update the latest kernel.
        whether match the firmwares
          it already has files for firmwares in /system/etc/firmware/*
          do not know the public latest kernel whether can match them.
        whether need special image packing
          the vendor use additional tools for image packing:
            CONFIG_INITRAMFS_SOURCE="scripts/FriendlyARM.cpio"
          do not know the public latest kernel whether also need it.

Choice:
  A) need choose another suitable branch of public kernel for it ?
  B) need additional configuration and download additional patches ?
  C) can not use latest public kernel to update latest android kernel ?
  D) none of choices above.


  welcome any members to providing suggestions or completions.

  thanks

-- 
Chen Gang

Flying Transformer

--------------010006000403060605000203
Content-Type: text/x-vcard; charset=utf-8;
 name="chen_gang_flying_transformer.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="chen_gang_flying_transformer.vcf"

YmVnaW46dmNhcmQNCmZuOkNoZW4gR2FuZw0Kbjo7Q2hlbiBHYW5nDQp2ZXJzaW9uOjIuMQ0K
ZW5kOnZjYXJkDQoNCg==
--------------010006000403060605000203--
