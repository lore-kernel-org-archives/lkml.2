Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab2DJSEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 14:04:23 -0400
Received: from www17.your-server.de ([213.133.104.17]:36349 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab2DJSEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 14:04:22 -0400
Message-ID: <1334081054.1431.23.camel@localhost.localdomain>
Subject: How to skip the initramfs?
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 10 Apr 2012 20:04:14 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How to skip the execution of the initramfs? option "noinitrd" doesn't
seem to work on 3.0 kernel.

Or is there an option to build an abootimg without initramfs? I didn't
find one.

with kind regards
thomas


