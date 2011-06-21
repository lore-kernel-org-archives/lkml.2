Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab1FUVSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 17:18:35 -0400
Received: from mxs.selfip.ru ([77.221.143.26]:43521 "EHLO mxs.selfmail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752792Ab1FUVSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 17:18:33 -0400
X-ACL-SPF: 
Subject: ioctl_fsfreeze and FIFREEZE timeout value
From: Vasiliy G Tolstov <v.tolstov@selfip.ru>
Reply-To: v.tolstov@selfip.ru
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Selfip.Ru
Date: Wed, 22 Jun 2011 01:18:19 +0400
Message-ID: <1308691099.2336.10.camel@mobile>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-ACL-DATA: Invalid Message-Id
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello. Sorry for e-mail to, may be, wrong list.
I'm try out use FIFREEZE ioctl to do some magic stuff with fs, as i read
lkml some version of patch contains ability to set timeout for fs
freeze, but now i check kernel git and does not see any params for
freeze to setup timeout.
I'm use linux-3.0.0-rc3, ioctl run returns success, but fs does not
unfrozen after timeout.
Where my mistake or may be this feature not included in kernel now ?


