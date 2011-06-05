Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab1FEDmO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 23:42:14 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:64048 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab1FEDmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 23:42:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :user-agent;
        b=LsRS6/mcJa8WBRaMB9xcHp+Fx9ZNpcqX/0PQcJpOSgjbRAeHCfPw8u+jyklmc+LET4
         Moj/JK8EP/BnNZM1PCU4xF40/tcCQCh4nhp5ES0EvyC3XqODs9CIqxnbJ+AZr9JLeG/b
         vQ0D6APcqVHp+1G4GYiP3Ztc5kHd9HU248sP4=
Date: Sun, 5 Jun 2011 11:41:14 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, akpm@linux-foundation.org
Subject: [Oops]RFC:include/trace/events/btrfs.h
Message-ID: <20110605034111.GA7215@gmail.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, greg@kroah.com,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harry Wei <harryxiyou@gmail.com>

When i compile 2.6.39.1, it shows something wrong
like below. When i open the file include/trace/events/btrfs.h
i don't know how to fix these oops. They just give the entry
of the function. So i can't get the exact line of the warnings.
Can anyone give me some suggestions?

Thanks in advance.
Harry Wei

In file included from include/trace/ftrace.h:283,
                    from include/trace/define_trace.h:96,
		                     from include/trace/events/btrfs.h:667,
				                      from fs/btrfs/super.c:56:
include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs_transaction_commit���:
include/trace/events/btrfs.h:47: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:47: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:47: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs__inode���:
include/trace/events/btrfs.h:68: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:68: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:68: warning: large integer implicitly truncated to unsigned type
   include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs_get_extent���:
   include/trace/events/btrfs.h:144: warning: large integer implicitly truncated to unsigned type
 include/trace/events/btrfs.h:144: warning: large integer implicitly truncated to unsigned type
 include/trace/events/btrfs.h:144: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:144: warning: large integer implicitly truncated to unsigned type
 include/trace/events/btrfs.h:144: warning: large integer implicitly truncated to unsigned type
 include/trace/events/btrfs.h:144: warning: large integer implicitly truncated to unsigned type
  include/trace/events/btrfs.h:144: warning: large integer implicitly truncated to unsigned type
  include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs__ordered_extent���:
  include/trace/events/btrfs.h:197: warning: large integer implicitly truncated to unsigned type
  include/trace/events/btrfs.h:197: warning: large integer implicitly truncated to unsigned type
 include/trace/events/btrfs.h:197: warning: large integer implicitly truncated to unsigned type
  include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs__writepage���:
 include/trace/events/btrfs.h:273: warning: large integer implicitly truncated to unsigned type
nclude/trace/events/btrfs.h:273: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:273: warning: large integer implicitly truncated to unsigned type
 include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs_writepage_end_io_hook���:
clude/trace/events/btrfs.h:332: warning: large integer implicitly truncated to unsigned type
 include/trace/events/btrfs.h:332: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:332: warning: large integer implicitly truncated to unsigned type
 include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs_sync_file���:
nclude/trace/events/btrfs.h:365: warning: large integer implicitly truncated to unsigned type
nclude/trace/events/btrfs.h:365: warning: large integer implicitly truncated to unsigned type
 include/trace/events/btrfs.h:365: warning: large integer implicitly truncated to unsigned type
 include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs_delayed_tree_ref���:
nclude/trace/events/btrfs.h:420: warning: large integer implicitly truncated to unsigned type
nclude/trace/events/btrfs.h:420: warning: large integer implicitly truncated to unsigned type
clude/trace/events/btrfs.h:420: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:420: warning: large integer implicitly truncated to unsigned type
 include/trace/events/btrfs.h:420: warning: large integer implicitly truncated to unsigned type
 include/trace/events/btrfs.h:420: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs_delayed_data_ref���:
include/trace/events/btrfs.h:459: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:459: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:459: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:459: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:459: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:459: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs__chunk���:
include/trace/events/btrfs.h:541: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:541: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:541: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs_cow_block���:
include/trace/events/btrfs.h:591: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:591: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:591: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h: In function ���ftrace_raw_output_btrfs__reserved_extent���:
include/trace/events/btrfs.h:626: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:626: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:626: warning: large integer implicitly truncated to unsigned type

