Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1JTVIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:08:24 -0400
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:35656
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752198Ab1JTVIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:08:21 -0400
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>
Subject: [RFC PATCH 0/17] Miscellaneous generic PHY layer improvements
Date: Thu, 20 Oct 2011 17:00:07 -0400
Message-Id: <1319144425-15547-1-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I have had the following series of phylib improvements and bugfixes
kicking around in a GIT repository for over a year and I finally
decided to get around to submitting them.

They are some preparatory work for later patches that I am still
working on to support unidirectional ethernet links in phylib.

These patches are currently based on v3.1-rc9; I apologize if these
conflict with any existing ongoing work.  Please let me know and I am
happy to respin against the appropriate tree.

Cheers,
Kyle Moffett

--
Curious about my work on the Debian powerpcspe port?
I'm keeping a blog here: http://pureperl.blogspot.com/

