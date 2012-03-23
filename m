Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab2CWD4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 23:56:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210Ab2CWD4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 23:56:04 -0400
Date: Thu, 22 Mar 2012 23:56:01 -0400
From: Dave Jones <davej@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: MTRR cleanup output
Message-ID: <20120323035601.GB12180@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Yinghai Lu <yinghai@kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While noticing that MSR spew, I also noticed this machine is really
verbose in it's output from the MTRR sanitiser.

http://codemonkey.org.uk/junk/dmesg.txt

Could we do better there? Or is this a case where specifying by hand is
the only solution ?

	Dave

