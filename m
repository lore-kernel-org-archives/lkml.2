Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120Ab1ECVyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 17:54:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34556 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab1ECVyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 17:54:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=StDRvZFgzzthXHETtfr0VT9pnL3R71etQLUpyDwjJ/68MTPUTz99YpGD4QUzQav5j4
         7NQmlBOspM2tGRVXdA1+kQps2DHripnkOYJ/1FmOHVhXPmqvpMFNE5pIStXeh5j8m6eW
         1eqMVnVGm+XdRZkDlfsgVLzTyvBgJjEBd4Gek=
MIME-Version: 1.0
Date: Tue, 3 May 2011 18:54:13 -0300
Message-ID: <BANLkTik4bW7nRMFXKW-UpfrSsaimEQ=zWg@mail.gmail.com>
Subject: regulators: kzalloc doubt
From: Thiago Farina <tfransosi@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        linux list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

What is the preferred way to use kzalloc? I have seen two ways under
drivers/regulator/.

1-

struct my_regulator_info *info = NULL;

info = kzalloc(sizeof(struct my_regulator_info), GFP_KERNEL);

2-

struct my_regulator_info *info;

info = kzalloc(sizeof(*info), GFP_KERNEL);
