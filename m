Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750875Ab0HRCW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 22:22:29 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58929 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab0HRCWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 22:22:23 -0400
Date: Tue, 17 Aug 2010 19:22:10 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Tomasz Buchert <tomasz.buchert@inria.fr>
Cc: Matt Helsley <matthltc@us.ibm.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] cgroup_freezer: Freezing and task move race fix
Message-ID: <20100818022210.GH3648@count0.beaverton.ibm.com>
References: <1281470001-14320-1-git-send-email-tomasz.buchert@inria.fr>
 <20100810215741.GC2927@count0.beaverton.ibm.com>
 <4C61D044.2060703@inria.fr>
 <20100811042738.GH2927@count0.beaverton.ibm.com>
 <4C6252CF.1090100@inria.fr>
 <20100812002154.GJ2927@count0.beaverton.ibm.com>
 <4C634605.50301@inria.fr>
 <20100812201334.GA29096@count0.beaverton.ibm.com>
 <4C6B339E.6010907@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C6B339E.6010907@inria.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 03:13:02AM +0200, Tomasz Buchert wrote:
> Le 12/08/2010 22:13, Matt Helsley a écrit :

<snip>

> 
> Matt,
> Am I supposed to do something right now? The discussion
> became a bit quiet recently.
> 
> Cheers,
> Tomasz

Hi Tomasz,

	I'm sorry. I haven't had much time to review your latest
patches and comment. I thought Andrew put them in his -mm tree
so I don't think you have anything to do at the moment.

Cheers,
	-Matt
