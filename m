Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab1G2JsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 05:48:13 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:60105 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab1G2JsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 05:48:11 -0400
Message-ID: <4E328070.3040804@gmail.com>
Date: Fri, 29 Jul 2011 11:42:08 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>, torvalds@linux-foundation.org
CC: hch@infradead.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: fs: take the ACL checks to common code
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

there is a little error for the commit in object in the current Linus's 
tree. For ext2, in acl.h there is a double definition of ext2_get_acl.

Regards,

Marco
