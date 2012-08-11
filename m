Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab2HKWdZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 18:33:25 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:34253 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab2HKWdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 18:33:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-usb@vger.kernel.org
Subject: [Regression, post-3.5] NULL pointer dereference in usb-wwan after resume from system suspend
Date: Sun, 12 Aug 2012 00:39:19 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Matthias Urlichs <smurf@smurf.noris.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208120039.19463.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The usb-wwan driver triggers a NULL pointer dereference oops after resume
from system suspend on my Toshiba Portege R500, but since that driver
hasn't changed since v3.5 and it is only used by the option driver, I suppose
that the latter is responsible for that.

This is a clear regression from v3.5, it hasn't happened ever before.

I'll collect some details tomorrow.

Thanks,
Rafael
