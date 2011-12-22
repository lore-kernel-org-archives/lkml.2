Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab1LVJKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 04:10:32 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57887 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab1LVJK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 04:10:29 -0500
Date: Thu, 22 Dec 2011 09:10:22 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com
Subject: Re: [PATCH v2 0/2] vfs: truncate bug fixes
Message-ID: <20111222091022.GO23916@ZenIV.linux.org.uk>
References: <cover.1324543719.git.dmitry.kasatkin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1324543719.git.dmitry.kasatkin@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 10:55:24AM +0200, Dmitry Kasatkin wrote:
> When a file is opened with O_TRUNC or truncated with truncate()/ftruncate(),
> and then closed, iversion is not updated. This patch uses ATTR_OPEN flag,
> which is currently used to identify files opened with O_TRUNC,
> as an indication to increment iversion.
> Also it adds passing of this flag from do_sys_truncate and do_sys_ftruncate.
> To reflect real meaning, ATTR_OPEN is suggested to be renamed to ATTR_TRUNC.

Um...  Is there any difference left between that and ATTR_SIZE, then?
