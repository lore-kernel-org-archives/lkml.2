Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933857Ab2J0AbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 20:31:18 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:41082 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab2J0AbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 20:31:17 -0400
Subject: target-pending updated to v3.7-rc2
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Oct 2012 17:31:14 -0700
Message-ID: <1351297874.13631.54.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

This is a just friendly heads up that target-pending has been updated to
latest v3.7-rc2 mainline code.  As usual, the for-next* branches have
been recreated from master and include in-flight target development
patches destined for upstream during the v3.8 merge window.

Also, a heads up for bleeding edge users of for-next/auto-next branches.
There are some SCSI reservations related items that still need to be
resolved for-3.8 code, so please be careful when using SCSI reservations
logic with the current bleeding edge target-pending code.

Thanks!

--nab



