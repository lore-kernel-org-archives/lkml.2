Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab0HAWig (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 18:38:36 -0400
Received: from n2-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.155]:24369 "HELO
	n2-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751741Ab0HAWif convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 18:38:35 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 961717.50570.bm@omp119.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=4gGF0aNtwpbBY0ntWH7M0RRA7ZybNR6OHh69U+KPJuDCSNi+I9AWGc41p7vafQOzG3IKNRjL3icZxnbRWYwLAZnbM0eAlLB/2vka5ZmmJ9Np+ZMJhQ4KzIhBPkJr+kwnKauWbVwbSiV4tv1pUqt75EZdXiG06tgM96yzazJE6I4=;
Message-ID: <866453.87809.qm@web180313.mail.gq1.yahoo.com>
X-YMail-OSG: ngkp0Y0VM1kCoLMmRZTMDcOwPxso9FWtBfIiSpL4neSRu6b
 P0h7lIvpi.dgcykwDTVq8Z5xsY6ajehor_aQMCLte6.6c8PkChqXUQOVrv_L
 gLkiBuzfbmRFgt0ZJLJMfqY7iGVZhV7ByKZniC9LplgtPVt.2NHdafKIaq3B
 UnGEr.rwfE9.4v68zY4OdS70t9OpRD9Fv8ZXPpWZ4QieGRZayvYfYASd3zYu
 w5iq2c4vz_2Im_GCQ3d0ic5JC.jtKtB8bjUS01GNcpZeEZMsvO1v9w4hYM01
 BktJt.DG1FBC8Qp2esQZ9Sb2ex_04IgQfOqDhO9Y-
X-Mailer: YahooMailClassic/11.2.4 YahooMailWebService/0.8.105.279950
Date: Sun, 1 Aug 2010 15:38:34 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: peterz@infradead.org, swetland@google.com, linux-kernel@vger.kernel.org,
        florian@mickler.org, linux-pm@lists.linux-foundation.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
In-Reply-To: <Pine.LNX.4.44L0.1008011810300.22928-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I should have made a stronger point:
> "power-aware" is _not_ a good
> > > term for these applications. 

Strongly disagree.  The whole point is that they
ARE VERY MUCH AWARE and interact with a power
policy to achieve goals.

Like refusing to power down active subsystems,
or actively powering down inactive ones.
Q.E.D. ... "aware".


