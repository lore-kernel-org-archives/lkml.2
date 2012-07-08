Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab2GHUsP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 16:48:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44304 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab2GHUsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 16:48:12 -0400
MIME-Version: 1.0
Date: Sun, 8 Jul 2012 15:48:11 -0500
Message-ID: <CAB7xdimH3k1oTbt9wqzbZrdCw0RqTFuGrdbX8gvSqFY1Y4p+xQ@mail.gmail.com>
Subject: CPU in guest shorter than normal
From: sheng qiu <herbert1984106@gmail.com>
To: kvm <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

what kind of factor can cause the CPU in guest mode much shorter than
normal? usually it's around 60% whenever guest is busy handling
network workloads. while in my case, it is only 20%.

Thanks,
Sheng
