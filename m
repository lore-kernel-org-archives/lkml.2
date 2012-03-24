Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab2CXRpP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 13:45:15 -0400
Received: from queue03.mail.zen.net.uk ([212.23.3.237]:34708 "EHLO
	queue03.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab2CXRpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 13:45:13 -0400
X-Greylist: delayed 1071 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Mar 2012 13:45:13 EDT
From: Andrew Bird <ajb@spheresystems.co.uk>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Enable some ZTE modems to use the new QMI WWAN driver
Date: Sat, 24 Mar 2012 17:27:05 +0000
Message-Id: <1332610028-23308-1-git-send-email-ajb@spheresystems.co.uk>
X-Mailer: git-send-email 1.7.6.5
X-Originating-Smarthost04-IP: [82.71.70.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches enable the network devices on some Vodafone branded ZTE
devices to be bound by the new QMI / WWAN driver. I also suspect that
the K3765-Z would also work, but at the moment I can't get the network
interface to be recognised during probe.
