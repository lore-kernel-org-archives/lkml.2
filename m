Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992519Ab2KAVTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 17:19:33 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35245 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299Ab2KAVTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 17:19:31 -0400
Date: Thu, 1 Nov 2012 21:24:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?B?5p2o6IuP56uL?= Yang Su Li <suli@cs.wisc.edu>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
Message-ID: <20121101212418.140e3a82@pyramind.ukuu.org.uk>
In-Reply-To: <5092D90F.7020105@vlnb.net>
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
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How about that recently preliminary infrastructure to send ORDERED commands 
> instead of queue draining was deleted from the kernel, because "there's no 
> difference where to drain the queue, on the kernel or the storage side"?

Send patches.

Alan
