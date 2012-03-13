Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab2CMNoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:44:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603Ab2CMNoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:44:05 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Andrew Morton <akpm@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Davide Libenzi <davidel@xmailserver.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] poll: add poll_requested_events() and poll_does_not_wait()
Date: Tue, 13 Mar 2012 14:45:55 +0100
Message-Id: <1331646356-3449-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I'm re-submitting this patch on behalf of Hans Verkuil, who currently
is unavailable for kernel work due to personal circumstances and has asked
me to get this patch upstream for 3.4-rc1.

This patch has been posted and discussed multiple times, a previous version
has been reviewed by Al Viro and his comments have been addressed in this
version. Getting this patch upstream is long overdue esp. since it has not
had any negative feedback. The only problem is that it is unclear through
which tree this patch should go upstream, the last discussion on this
subject was here:
http://lkml.indiana.edu/hypermail/linux/kernel/1202.0/01341.html

Regards,

Hans
