Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab2AQNGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:06:00 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52583 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab2AQNF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:05:59 -0500
Message-ID: <4F157233.2010503@kernel.org>
Date: Tue, 17 Jan 2012 08:05:55 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ying.huang@intel.com, Chen Gong <gong.chen@linux.intel.com>
Subject: Re: [PATCH] acpi/apei/einj: Add extensions to EINJ from rev 5.0 of
 acpi spec
References: <212c4cabb390880e855be9509e7d2be002699907.1325716284.git.tony.luck@intel.com>
In-Reply-To: <212c4cabb390880e855be9509e7d2be002699907.1325716284.git.tony.luck@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch doesn't build in 32-bit mode:

drivers/acpi/apei/einj.c:256:3: error: implicit declaration of function ‘readq’ [-Werror=implicit-function-declaration]

