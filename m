Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab2CYKKn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 06:10:43 -0400
Received: from smarthost03.mail.zen.net.uk ([212.23.3.142]:49830 "EHLO
	smarthost03.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755500Ab2CYKKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 06:10:40 -0400
From: Andrew Bird <ajb@spheresystems.co.uk>
To: gregkh@linuxfoundation.org
Cc: smurf@smurf.noris.de, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Enable some ZTE modems to use the new QMI WWAN driver
Date: Sun, 25 Mar 2012 11:10:26 +0100
Message-Id: <1332670229-2045-1-git-send-email-ajb@spheresystems.co.uk>
X-Mailer: git-send-email 1.7.6.5
X-Originating-Smarthost03-IP: [82.71.70.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches enable the network devices on some Vodafone branded ZTE
devices to be bound by the new QMI / WWAN driver. I suspect that the
K3765-Z would also work, but at the moment I can't get the network
interface to be recognised during probe.

(Reposted as previously I didn't cc netdev)
