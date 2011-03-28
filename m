Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab1C1SFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:05:22 -0400
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:38363 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932122Ab1C1SFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:05:21 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-17.arcor-online.net CFED1CC389
Message-ID: <4D90CDDE.1020500@df1tl.local.here>
Date: Mon, 28 Mar 2011 20:05:18 +0200
From: Klaus Dittrich <kladit@arcor.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.2.15) Gecko/20110304 Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.37.6   2.6.38.2  tst-aio4.c
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reverting the patch of kernel/signal.c which was
applied to 2.6.37.6 and  2.6.38.2 solved the problem.
