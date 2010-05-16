Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab0EPI67 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 04:58:59 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:41476 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203Ab0EPI66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 04:58:58 -0400
Date: Sun, 16 May 2010 10:58:52 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: ERR_PTR and PTR_ERR
Message-ID: <Pine.LNX.4.64.1005161055580.6573@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see a number of occurrences of code like the following:

 	if (IS_ERR(alg))
		return ERR_PTR(PTR_ERR(alg));

Is there any reason why the second line couldn't just be return alg?

julia
