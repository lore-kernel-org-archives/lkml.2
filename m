Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab0FICv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 22:51:57 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:45084 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab0FICv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 22:51:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=R11ACV6mP7HuM2+avEv0KO8zXVsP0bD+wjRKqYD9ceOlDLEO9Sg59Ue6e0QdJ9tpI8
         Ql4o/bQ38ovQxiAN/bn+Ssp1WxAUjGGXNb8zPxkR3dHDOtu+WnacpX+vr9IApcv0vn7R
         Fzrfn7Eh2LV+S94TdX3Qr5Z9gtmiDhIzNMUJ0=
Message-ID: <4C0F01E4.1030507@lwfinger.net>
Date: Tue, 08 Jun 2010 21:52:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.20 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #16122] 2.6.35-rc1: WARNING at fs/fs-writeback.c:1142 __mark_inode_dirty+0x103/0x170
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera> <C9Q3XEnHPeG.A.gdG.f8rDMB@chimera>
In-Reply-To: <C9Q3XEnHPeG.A.gdG.f8rDMB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 05:10 PM, Rafael J. Wysocki wrote:
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
> Date		: 2010-06-04 13:18 (5 days old)

Still present in 2.6.35-rc2.

Larry
