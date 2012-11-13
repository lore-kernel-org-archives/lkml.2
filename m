Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab2KMRf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:35:29 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50880 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454Ab2KMRfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:35:19 -0500
Date: Tue, 13 Nov 2012 17:40:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Howard Chu <hyc@symas.com>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        "Theodore Ts'o" <tytso@mit.edu>, drh@hwaci.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [sqlite] light weight write barriers
Message-ID: <20121113174000.6457a68b@pyramind.ukuu.org.uk>
In-Reply-To: <50A1C15E.2080605@vlnb.net>
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>
	<m2fw5mtffg.fsf_-_@firstfloor.org>
	<CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>
	<5086F5A7.9090406@vlnb.net>
	<20121025051445.GA9860@thunk.org>
	<508B3EED.2080003@vlnb.net>
	<20121027044456.GA2764@thunk.org>
	<5090532D.4050902@vlnb.net>
	<20121031095404.0ac18a4b@pyramind.ukuu.org.uk>
	<5092D90F.7020105@vlnb.net>
	<20121101212418.140e3a82@pyramind.ukuu.org.uk>
	<50931601.4060102@symas.com>
	<20121102123359.2479a7dc@pyramind.ukuu.org.uk>
	<50A1C15E.2080605@vlnb.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Barriers are pretty much universal as you need them for power off !
> 
> I'm afraid, no storage (drives, if you like this term more) at the moment supports 
> barriers and, as far as I know the storage history, has never supported.

The ATA cache flush is a write barrier, and given you have no NV cache
visible to the controller it's the same thing.

> Instead, what storage does support in this area are:

Yes - the devil is in the detail once you go beyond simple capabilities.

Alan
