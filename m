Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935316Ab2JaJta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:49:30 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:32776 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935266Ab2JaJtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:49:23 -0400
Date: Wed, 31 Oct 2012 09:54:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?B?5p2o6IuP56uL?= Yang Su Li <suli@cs.wisc.edu>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
Message-ID: <20121031095404.0ac18a4b@pyramind.ukuu.org.uk>
In-Reply-To: <5090532D.4050902@vlnb.net>
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>
	<m2fw5mtffg.fsf_-_@firstfloor.org>
	<CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>
	<5086F5A7.9090406@vlnb.net>
	<20121025051445.GA9860@thunk.org>
	<508B3EED.2080003@vlnb.net>
	<20121027044456.GA2764@thunk.org>
	<5090532D.4050902@vlnb.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't want to flame on this topic, but you are not right here. As far as I can 
> see, a big chunk of Linux storage and file system developers are/were employed by 
> the "gold-plated storage" manufacturers, starting from FusionIO, SGI and Oracle.
> 
> You know, RedHat from recent times also stepped to this market, at least I saw 
> their advertisement on SDC 2012. So, you can add here all RedHat employees.

Booleans generally should be reserved for logic operators. Most of the
Linux companies work on both low and high end storage. The two are not
mutually exclusive nor do they divide neatly by market. Many big clouds
use cheap low end drives by the crate, some high end desktops are using
SAS although given you can get six 2.5" hotplug drives in a 5.25" bay I'm
not sure personally there is much point

(and I used to have fibrechannel on my Thinkpad 600 when docked 8))

> Our discussion started not from "value-for-money", but from a constant demand to 
> perform ordered commands without full queue draining, which is ignored by the 
> Linux storage developers for YEARS as not useful, right?

Send patches with benchmarks demonstrating it is useful. It's really
quite simple. Code talks.

Alan
