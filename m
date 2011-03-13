Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab1CMHl5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 03:41:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50462 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab1CMHl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 03:41:56 -0400
Date: Sun, 13 Mar 2011 07:41:54 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel@vger.kernel.org
Subject: Just what do you think F_SETFD is?
Message-ID: <20110313074154.GI22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	May I politely inquire about the technics used to write
smack_file_fcntl()?  Beyond "GET is kinda like read, SET is kinda
like write", that is - there must've been something, since F_DUPFD
also got, er, handled.

	Al, feeling a bit like Fermat - I think I have an adequate
flame, but it won't fit the maillist size limit...
