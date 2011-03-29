Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1C2HCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 03:02:24 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:36938 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751457Ab1C2HCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 03:02:23 -0400
Date: Tue, 29 Mar 2011 09:02:15 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: show autogroup cgroups using cgroup fs?
Message-ID: <20110329070215.GA6650@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

is there a way to display the autogroup-created cgroups using the cgroup
filesystems? 

$ mount none -t cgroup -o cpu cpu

merely displays one group containing everything, AFAICS.

Thanks,
	Dominik
