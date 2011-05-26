Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab1EZAEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 20:04:54 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52336 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab1EZAEx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 20:04:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=t7ohw7bnDy1xKBFpEjfF3DjP4d2t6jslqT4jipMcmaLJhKdKaWRDg2EbjmqXimJSm7
         Dcv82cS67DkDE6xRBSwKQ/1UFeSAWeXB1ieuonJC6lSd3vT6EY9NKYJqEWOVCLTetKUI
         N9jdpdRbG1rUKY1ZMP4nU4sfH2z5AfjzS9gnU=
MIME-Version: 1.0
Date: Thu, 26 May 2011 03:04:52 +0300
Message-ID: <BANLkTikNj7H3m1poPr+jU-O7znEXOst3jw@mail.gmail.com>
Subject: build error in current git
From: Anca Emanuel <anca.emanuel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC [M]  drivers/usb/serial/qcaux.o
drivers/video/mb862xx/mb862xx-i2c.c: In function ‘mb862xx_i2c_wait_event’:
drivers/video/mb862xx/mb862xx-i2c.c:25:3: error: implicit declaration
of function ‘udelay’
