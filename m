Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab1GXXRH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 19:17:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab1GXXRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 19:17:05 -0400
Date: Sun, 24 Jul 2011 19:17:01 -0400
From: Dave Jones <davej@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: kdevtmpfs oops since yesterdays vfs merge
Message-ID: <20110724231701.GA1707@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see an oops in handle_create when I try to boot current tree..

full trace:
https://s3.amazonaws.com/twitpic/photos/large/355006460.jpg?AWSAccessKeyId=AKIAJF3XCCKACR3QDMOA&Expires=1311550232&Signature=IIO%2Bya1uEDJzSXTD0DXh2%2BdZpoU%3D

	Dave

