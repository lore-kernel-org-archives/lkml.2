Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab1E3TJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 15:09:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58000 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab1E3TJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 15:09:49 -0400
Message-ID: <4DE3E9E7.8020008@zytor.com>
Date: Mon, 30 May 2011 12:03:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Turning off the incremental diff robot
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

With the v3.0 name change I was looking over what might break, and I'm
seriously considering turning off the incremental diff robot on
kernel.org.  It's not clear to me that it is actually useful anymore,
with git and all.

Do anyone actually use these anymore?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

