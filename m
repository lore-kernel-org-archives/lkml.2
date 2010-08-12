Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466Ab0HLUB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 16:01:29 -0400
Received: from www17.your-server.de ([213.133.104.17]:41894 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab0HLUB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 16:01:28 -0400
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.36: Sound stop working
Date: Thu, 12 Aug 2010 22:00:05 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-00268-gf70ab54; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008122200.05598.thomas@m3y3r.de>
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My sound card stop to work since a few commits. I tried to bisect it and ended up with this:

There are only 'skip'ped commits left to test.
The first bad commit could be any of:
3bcf3860a4ff9bbc522820b4b765e65e4deceb3e
c1e5c954020e123d30b4abf4038ce501861bcf9f
We cannot bisect more!

any ideas what to do now?

