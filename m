Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab1IWSSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 14:18:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35403 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab1IWSSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 14:18:37 -0400
MIME-Version: 1.0
Date: Fri, 23 Sep 2011 23:48:36 +0530
Message-ID: <CAAjPY7buwGHCtYwrskbHwJV_rK9nD7LiAyZOpgUbHFcWBFudWg@mail.gmail.com>
Subject: Use of inode for storing security info
From: Parag Amritkar <paragamritkar@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can we use any field of inode for storing information like storing
encryption key of that file?
If so then how?
