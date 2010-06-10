Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254Ab0FJOW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:22:58 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:38439 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759148Ab0FJOW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:22:57 -0400
Date: Thu, 10 Jun 2010 16:22:54 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some
 accesspoint == hardlock
Message-ID: <20100610142254.GD4452@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
References: <20100531201225.GA6327@localhost>
 <1275501085.2091.28873.camel@rchatre-DESK>
 <20100604165732.GB28003@localhost>
 <1276019189.1835.11781.camel@rchatre-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276019189.1835.11781.camel@rchatre-DESK>
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Reinette,

  Thanks for your message.

  Yes, you're right about the multiple bugs one thread thing.

  Just today I got registered w/ the wireless ml because the
  system just did not send me a registration message. 

  For the bug reports to be created it will take me some time.
  I'll firstly report the main issue, the 2 other ones afterwards.
  Would it be ok cross referencing i.e. to the log and such 
  between the reports?

  Should I paste all the mail messages in separate report messages 
  (belonging to one bug report, of course) or should I paste some
  links to the thread?

  Cheers,

        Nils

@John: Yes, you're right but the 2.6.33.4 tree which for me still
  has the bug_on in.


On Tue 2010-06-08 @ 10-46-29AM -0700, reinette chatre wrote: 
# On Fri, 2010-06-04 at 09:57 -0700, Nils Radtke wrote:
# > I haven't yet received a comment of yours regarding my many other questions in
# > my previous message. I am willing to help investigate more, assist in other ways 
# > than testing only (always only doing testing isn't a way to keep up fun..)
# 
# Your messages contain references to many issues and it is becoming
# increasingly hard to keep track of them all in a single email thread.
# Since the system crash is clearly the big issue I would like to focus on
# that and get that resolved. This is why I proposed that you create bug
# reports to help track your various issues better.
# 
# Reinette
# 
# 

-- 
