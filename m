Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab1C3IJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 04:09:40 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:59576 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab1C3IJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 04:09:31 -0400
Message-Id: <20110330080637.110679740@linux.vnet.ibm.com>
User-Agent: quilt/0.47-1
Date: Wed, 30 Mar 2011 10:06:37 +0200
From: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
To: robert.richter@amd.com
Cc: mingo@elte.hu, oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: v2 [patch 0/1] hwsampler_shutdown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Robert, 

yes, and you are right we should reset hws_state to zero.

Heinz

