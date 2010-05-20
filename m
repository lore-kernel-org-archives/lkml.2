Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab0ETL1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 07:27:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab0ETL1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 07:27:12 -0400
Date: Thu, 20 May 2010 13:26:56 +0200
From: Jan Kara <jack@suse.cz>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
       Arnd Bergmann <arnd@arndb.de>, Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       Dustin Kirkland <kirkland@canonical.com>,
       "H . Peter Anvin" <hpa@zytor.com>, Ian Kent <raven@themaw.net>,
       "J . Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
       Jeff Dike <jdike@addtoit.com>, Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       Jan Kara <jack@suse.cz>, Joern Engel <joern@logfs.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/8] Another set of ioctl bkl pushdown, almost the end
Message-ID: <20100520112656.GA3395@quack.suse.cz>
References: <1274289855-10001-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274289855-10001-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 19-05-10 19:24:07, Frederic Weisbecker wrote:
> We are very close to the end of struct file_operations::ioctl
> 
> What remains:
...
> 	udf: Approved but not yet included in udf tree
  It is included in udf tree and I will push it to Linus in this merge
window...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
