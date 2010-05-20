Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab0ETL2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 07:28:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35670 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab0ETL2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 07:28:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hDz8oJh+F463UXrPk5SAdNLmuz8TD4hK+X524yWU9Row/m44iNGS0P60SFoCB3hOoJ
         9lb8oVdMCCFyKs18J9P8wBqSYBlejrTZnNCY7rPgASlABgIaP4zGwpsLisGlQk0Qj8XZ
         4k1H0QsCa6mlAsaMcQNijr96eh0YdO3dDKZYU=
Date: Thu, 20 May 2010 13:28:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
       Arnd Bergmann <arnd@arndb.de>, Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       Dustin Kirkland <kirkland@canonical.com>,
       "H . Peter Anvin" <hpa@zytor.com>, Ian Kent <raven@themaw.net>,
       "J . Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
       Jeff Dike <jdike@addtoit.com>, Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       Joern Engel <joern@logfs.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/8] Another set of ioctl bkl pushdown, almost the end
Message-ID: <20100520112847.GE5309@nowhere>
References: <1274289855-10001-1-git-send-regression-fweisbec@gmail.com> <20100520112656.GA3395@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100520112656.GA3395@quack.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 01:26:56PM +0200, Jan Kara wrote:
> On Wed 19-05-10 19:24:07, Frederic Weisbecker wrote:
> > We are very close to the end of struct file_operations::ioctl
> > 
> > What remains:
> ...
> > 	udf: Approved but not yet included in udf tree
>   It is included in udf tree and I will push it to Linus in this merge
> window...


Thanks!

