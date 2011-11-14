Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1KNSgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 13:36:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab1KNSgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 13:36:40 -0500
Date: Mon, 14 Nov 2011 13:36:35 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: ying.huang@intel.com, kernel-team@fedoraproject.org, Matt_Domsch@dell.com
Subject: GHES: Failed to read error status
Message-ID: <20111114183635.GA6316@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, ying.huang@intel.com,
	kernel-team@fedoraproject.org, Matt_Domsch@dell.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears that there's a problem with Dell poweredge servers
and GHES judging by the bug reports at

https://bugzilla.redhat.com/show_bug.cgi?id=746755
https://bugs.launchpad.net/ubuntu/+bug/881164

Is this likely to be something that Dell need to fix in a firmware update,
or something that the code needs to accomodate ?

	Dave

