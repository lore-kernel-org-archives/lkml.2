Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945963Ab2EKSS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:18:27 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:32943 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab2EKSSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:18:25 -0400
Date: Fri, 11 May 2012 22:18:15 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, khlebnikov@openvz.org,
        xemul@parallels.com, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: c/r: broken locking when executing map_files
Message-ID: <20120511181815.GF1970@moon>
References: <1335979380.10666.6.camel@lappy>
 <20120502172756.GD2301@moon>
 <20120503173125.GF19347@moon>
 <20120505182051.GA16029@albatros>
 <20120505185306.GB28746@moon>
 <20120505193201.GA2500@moon>
 <20120506202132.GA6570@albatros>
 <20120506204904.GA1912@moon>
 <20120511175640.GA11238@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120511175640.GA11238@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 09:56:40PM +0400, Vasiliy Kulikov wrote:
> > 
> > Wait, the proc_map_files_lookup requires the caller to be cap-sysadmin
> > granted, would not this be enough?
> 
> Yes :-) You can also remove additional checks after capable() in
> readdir and revalidate functions.

Yup, I'll update. Thanks.

	Cyrill
