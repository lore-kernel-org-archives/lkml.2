Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030851Ab2GMSaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 14:30:24 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59850 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab2GMSaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 14:30:22 -0400
Message-ID: <50006933.4000004@linux.vnet.ibm.com>
Date: Fri, 13 Jul 2012 11:30:11 -0700
From: cody <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: allow long lines in config file
References: <1341964078-22594-1-git-send-email-cody@linux.vnet.ibm.com> <50001D87.1020708@suse.cz>
In-Reply-To: <50001D87.1020708@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071318-7282-0000-0000-00000AE76AF8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do we have any strict standards for what is and is not portable?

(I'm aware 'getline' was only added to posix ~4 years ago in 2008).

--
Cody

