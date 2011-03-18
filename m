Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab1CRJyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 05:54:43 -0400
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:34863 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932402Ab1CRJyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 05:54:37 -0400
Message-ID: <4D832BD0.4030809@blueyonder.co.uk>
Date: Fri, 18 Mar 2011 09:54:24 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7 ThunderBrowse/3.3.5
MIME-Version: 1.0
To: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: pstore build error
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slipstream:/usr/src/linux-2.6.38-git5 # make -j 4
   CHK     include/linux/version.h
   CHK     include/generated/utsrelease.h
   CALL    scripts/checksyscalls.sh
   CHK     include/generated/compile.h
   CC      fs/pstore/inode.o
   CC      fs/pstore/platform.o
fs/pstore/inode.c:253:2: error: unknown field ‘get_sb’ specified in 
initializer
fs/pstore/inode.c:253:2: warning: initialization makes integer from 
pointer without a cast
fs/pstore/inode.c:253:2: error: initializer element is not computable at 
load time
fs/pstore/inode.c:253:2: error: (near initialization for 
‘pstore_fs_type.fs_flags’)
make[2]: *** [fs/pstore/inode.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [fs/pstore] Error 2
make: *** [fs] Error 2
make: *** Waiting for unfinished jobs....
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support 
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

