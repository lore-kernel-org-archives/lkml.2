Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab2KQOJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 09:09:56 -0500
Received: from plane.gmane.org ([80.91.229.3]:39807 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab2KQOJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 09:09:55 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ricardo Nabinger Sanchez <rnsanchez@wait4.org>
Subject: Re: [RFC PATCH 0/5] enable runnable load avg in load balance
Date: Sat, 17 Nov 2012 13:49:49 +0000 (UTC)
Message-ID: <pan.2012.11.17.13.49.51@wait4.org>
References: <1353157457-3649-1-git-send-email-alex.shi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 187.60.101.50
User-Agent: Pan/0.139 (Sexual Chocolate; GIT bf56508
	git://git.gnome.org/pan2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2012 21:04:12 +0800, Alex Shi wrote:

> This patchset try to consider runnable load avg when do cpu load
> comparison in load balance.

I found the wording in the commit messages (pretty much all of them, 
including the introductory message) rather confusing, especially patch 
4/5.


-- 
Ricardo Nabinger Sanchez           http://rnsanchez.wait4.org/
  "Left to themselves, things tend to go from bad to worse."

