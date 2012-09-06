Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab2IFIyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 04:54:47 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37037 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab2IFIyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 04:54:45 -0400
Date: Thu, 6 Sep 2012 16:54:17 +0800
From: Adam Lee <adam8157@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Yaakov Selkowitz <yselkowitz@users.sourceforge.net>,
        Peter Foley <pefoley2@verizon.net>, Paul Bolle <pebolle@tiscali.nl>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "open list:KCONFIG" <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH v3] kconfig: replace 'oldnoconfig' with 'olddefconfig',
 and keep the old name as an alias
Message-ID: <20120906085417.GA22428@adam-station.nay.redhat.com>
References: <1346428476-12061-1-git-send-email-adam8157@gmail.com>
 <1346432721-22521-1-git-send-email-adam8157@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346432721-22521-1-git-send-email-adam8157@gmail.com>
X-PGP-Key-ID: 2F39D84D
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2012 at 01:05:17AM +0800, Adam Lee wrote:
> As 67d34a6a391369269a2e5dba8a5f42cc4cd50231 said, 'oldnoconfig' doesn't
> set new symbols to 'n', but instead sets it to their default values.
> 
> So, this patch replaces 'oldnoconfig' with 'olddefconfig', stop making
> people confused, and keep the old name 'oldnoconfig' as an alias,
> because people already are dependent on its behavior with the
> counter-intuitive name.
> 
> v3: use a better way an add comments about alias in conf.c

Hi, Michal

How about this version? I replace it and keep the old one as an alias,
seems everyone will be happy, not have to stand the counter-intuitive
name.

-- 
Regards,
Adam Lee
http://adam8157.info
