Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab1HPXUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 19:20:21 -0400
Received: from smarthost03.mail.zen.net.uk ([212.23.3.142]:54303 "EHLO
	smarthost03.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431Ab1HPXUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 19:20:19 -0400
From: Andrew Bird <ajb@spheresystems.co.uk>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: USB option driver PID updates
Date: Wed, 17 Aug 2011 00:20:01 +0100
Message-Id: <1313536804-5675-1-git-send-email-ajb@spheresystems.co.uk>
X-Mailer: git-send-email 1.7.3.2
X-Originating-Smarthost03-IP: [82.71.70.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a slightly updated patchset for the one that Alex just posted.
It's rebased against latest master, and also prevents binding of the
CDC_DATA interface where necessary.
