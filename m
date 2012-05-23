Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab2EWGMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:12:21 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38824 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751623Ab2EWGMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:12:18 -0400
Message-ID: <1337753534.13111.51.camel@joe2Laptop>
Subject: Re: [PATCH] Add human-readable units modifier to vsnprintf()
From: Joe Perches <joe@perches.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Tejun Heo <tejun@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
Date: Tue, 22 May 2012 23:12:14 -0700
In-Reply-To: <20120523060435.GD14312@dhcp-172-18-216-138.mtv.corp.google.com>
References: <cover.1336619038.git.koverstreet@google.com>
	 <c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
	 <20120522211706.GH14339@google.com>
	 <20120523031214.GA607@dhcp-172-18-216-138.mtv.corp.google.com>
	 <1337744190.13111.33.camel@joe2Laptop>
	 <20120523045023.GE607@dhcp-172-18-216-138.mtv.corp.google.com>
	 <1337749848.13111.40.camel@joe2Laptop>
	 <20120523052236.GA14312@dhcp-172-18-216-138.mtv.corp.google.com>
	 <1337751760.13111.47.camel@joe2Laptop>
	 <20120523060435.GD14312@dhcp-172-18-216-138.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 02:04 -0400, Kent Overstreet wrote:
> Only trouble is we lose the existing method of specifying the type of
> the integer. 

Hi again Kent.

My first suggestion to you was:
---------------------
> or maybe yet another lib/vsprintf pointer extension
> like %pD with some descriptors after the %pD for
> type, width and precision.
---------------------

For instance, internet addresses use pointer extensions
%pI4 and %pI6 for ipv4 and ipv6 addresses.

> New flag character would make much more sense... if gcc
> could be persuaded.

It can't be so persuaded though.  Maybe a future gcc.

