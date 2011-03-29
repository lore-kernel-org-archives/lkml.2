Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab1C2JDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 05:03:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62969 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1C2JDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 05:03:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=UQ5LXX5uhM6EfdcH2XwhY3dykJ0tpEm1c1B8gmsPW0eTtZGOMNuKABC6YUkjZtrbzW
         IfwUFnwFPSrMApY84/zVhyIXlYNKxSkjPzpqvYtzsprgJW/M0RDoB0vpjc7QQTFfqQCg
         GXHRjb+4zo3tD3HARUG8EZItoHHeMgAXYrTi0=
Date: Tue, 29 Mar 2011 11:02:48 +0200
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: lkml <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: ptrace pull request for linux-next
Message-ID: <20110329090248.GJ6736@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Stephen.

Can you please pull from the following tree into linux-next?

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git ptrace

The tree hosts ongoing ptrace/group stop improvements.  Oleg is in the
process of getting a korg account and setting up a dedicated tree and
it has been agreed that I maintain a temporary tree to be tested in
linux-next until things are properly setup.  The branch is stable and
will be pulled verbatim into Oleg's tree once it's up and running.

Thank you.

-- 
tejun
