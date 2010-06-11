Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab0FKQ1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 12:27:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:49482 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab0FKQ1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 12:27:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,404,1272870000"; 
   d="scan'208";a="287841080"
Subject: Re: iwl3945 bug in 2.6.34
From: reinette chatre <reinette.chatre@intel.com>
To: Satish Eerpini <eerpini@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTillaEGISTjW4iqpsNsJbaE6ZW7pqYvAzoBrkI69@mail.gmail.com>
References: <AANLkTik_7rxDBc0TKlAfoYyM5S6Cf_Hyxbr4W5ORnTsq@mail.gmail.com>
	 <1274726029.2091.15160.camel@rchatre-DESK>
	 <1274738896.2091.15438.camel@rchatre-DESK>
	 <1274830187.2091.17034.camel@rchatre-DESK>
	 <1275600737.2091.32332.camel@rchatre-DESK>
	 <AANLkTinfoyhEyFjxReR6Oza7r_AQhcyMlpaXYB4ZjjlU@mail.gmail.com>
	 <AANLkTillaEGISTjW4iqpsNsJbaE6ZW7pqYvAzoBrkI69@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Jun 2010 09:27:27 -0700
Message-ID: <1276273647.25793.1210.camel@rchatre-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 04:39 -0700, Satish Eerpini wrote:
> The 2.6.34 vanilla kernel with the above patches applied crashed again
> today, I was amidst a conference on webex when this happened, still
> not able to figure out what is the kind of traffic that causes the
> driver to give up ... here is output from dmesg :

Instead of duplicate posts to the list and bugzilla, lets just continue
debugging this at https://bugzilla.kernel.org/show_bug.cgi?id=16084 - I
responded there to your message.

Thanks

Reinette


