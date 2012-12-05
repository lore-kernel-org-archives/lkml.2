Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab2LEUvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 15:51:43 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:37439 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754437Ab2LEUvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 15:51:31 -0500
From: Sebastian Hahn <snsehahn@cip.cs.fau.de>
To: gregkh@linuxfoundation.org
Cc: Jennifer.Naumann@informatik.stud.uni-erlangen.de, dan.carpenter@oracle.com,
        standby24x7@gmail.com, Julia.Lawall@lip6.fr, jkosina@suse.cz,
        joe@perches.com, yongjun_wei@trendmicro.com.cn,
        adam.buchbinder@gmail.com, amwang@redhat.com, justinmattock@gmail.com,
        wfp5p@virginia.edu, jim.cromie@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de
Subject: [PATCH 0/6] staging:rtl8192u: begin cleanup of some checkpatch errors
Date: Wed,  5 Dec 2012 21:40:17 +0100
Message-Id: <1354740023-30849-1-git-send-email-snsehahn@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jennifer and I have started making the rtl8192u driver conform with the
CodingStyle rules a little better. We started out with a cleanfile run,
then did corrections for individual issues, grouped into patches by
specific issue fixed.

Note that this is in no way a complete cleanup, and since we contained
logical changes to single commits none of the commits pass checkpatch
themselves, as there's much more work to be done here.

