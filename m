Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab0EHMcP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 08:32:15 -0400
Received: from lazybastard.de ([212.112.238.170]:58552 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab0EHMcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 08:32:13 -0400
Date: Sat, 8 May 2010 14:32:00 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the logfs tree
Message-ID: <20100508123200.GD21185@logfs.org>
References: <20100507094638.11351234.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100507094638.11351234.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 May 2010 09:46:38 +1000, Stephen Rothwell wrote:
> 
> After merging the logfs tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
> 
> fs/logfs/file.c: In function 'logfs_fsync':
> fs/logfs/file.c:225: warning: unused variable 'super'
> 
> Introduced by commit c0c79c31c9d5fcc19812c6c35f842baf50ee788a ("logfs:
> fix sync").

Thanks, fixed.

Jörn

-- 
The grand essentials of happiness are: something to do, something to
love, and something to hope for.
-- Allan K. Chalmers
