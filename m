Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab2EBIVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 04:21:01 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57040 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab2EBIU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 04:20:58 -0400
MIME-Version: 1.0
Date: Wed, 2 May 2012 10:20:58 +0200
Message-ID: <CADieKzsP6o=C2RBJRJ5RDi5dJLQ7HOzf5fDPY0tgUsx3E-AKCw@mail.gmail.com>
Subject: product_uuid root RO why?
From: phi gcc <phi.gcc@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I see that /sys/devices/virtual/dmi/id/product_uuid is RO for root
only. Is there some rationale for this? I saw post saying it is for
security reasons, can someone explain?.

Cheers,
Phi
