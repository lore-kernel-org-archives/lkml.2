Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab0FUCVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 22:21:46 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43657 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757778Ab0FUCVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 22:21:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eN2lYebLPFV9IPbRVwJScEp7WWTOE104FT28sj4BNw7fpDiPYdZe5FsJRQQvYhuh1K
         dYuvzZ9P6jAqgjCTKD9uEAJYJ7HPispXHLZID7QUn/w01COluDzhBznEcuUxG+Rgi1QG
         +DS+sWdIWf9Pg+W2zSjD4Nf9y8n60VeWAaLEc=
Message-ID: <4C1ECCDE.6050803@lwfinger.net>
Date: Sun, 20 Jun 2010 21:22:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #16122] 2.6.35-rc1: WARNING at fs/fs-writeback.c:1142 __mark_inode_dirty+0x103/0x170
References: <lc60d4toGTL.A.QzD._LpHMB@chimera> <W8JfMs9cZw.A.N1G.5NpHMB@chimera>
In-Reply-To: <W8JfMs9cZw.A.N1G.5NpHMB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2010 05:17 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16122
> Subject		: 2.6.35-rc1: WARNING at fs/fs-writeback.c:1142 __mark_inode_dirty+0x103/0x170
> Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> Date		: 2010-06-04 13:18 (17 days old)

This is still present in rc3.

Larry
