Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab1AaKZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:25:41 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:43364 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab1AaKZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:25:38 -0500
From: Daniel Lezcano <daniel.lezcano@free.fr>
To: akpm@linux-foundation.org
Cc: ebiederm@xmission.com, oleg@redhat.com,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        clg@fr.ibm.com
Subject: Prepare for the unshare support of the pid namespace
Date: Mon, 31 Jan 2011 11:25:21 +0100
Message-Id: <1296469525-30111-1-git-send-email-daniel.lezcano@free.fr>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is a cleanup and a preparation to unshare the pid
namespace. These prerequisites prepares the next Eric's patchset
to give a file descriptor to a namespace and join an existing
namespace.

The initial authors of this patchset are Eric Biederman and Oleg
Nesterov.

Changelog:
	01/31/11 - Daniel Lezcano <daniel.lezcano@free.fr>
	* patch 1/4 : wrapped test in a function
	* other patches : refreshed against linux-next


