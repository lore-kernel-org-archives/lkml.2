Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab1BBBbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:31:41 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:41831 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1BBBbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 20:31:40 -0500
Subject: PPS build warning
From: john stultz <johnstul@us.ibm.com>
To: Rodolfo Giometti <giometti@linux.it>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 17:31:33 -0800
Message-ID: <1296610293.3336.142.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Rodolfo,
	Just ran into the following:

drivers/pps/kapi.c: In function ‘pps_event’:
drivers/pps/kapi.c:196: warning: ‘ts_real.flags’ may be used uninitialized in this function

Looks like you don't set the flags value in timespec_to_pps_ktime when
you initialize the rest of the structure.

thanks
-john

