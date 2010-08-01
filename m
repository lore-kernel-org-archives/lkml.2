Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab0HAXTY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 19:19:24 -0400
Received: from n1-vm0.bullet.mail.gq1.yahoo.com ([67.195.23.152]:37302 "HELO
	n1-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751463Ab0HAXTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 19:19:23 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 354010.5520.bm@omp127.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=LSSY5+8DkxvLDa8koHcWAuhdjGWsPQ+wg131o+izGcfilHY0jDBOWesE+lzfsAxxs1NyjmOtKAy86NZuFS3OotdzdAd5FfEl/kEktEnhMj52s3juevEZNf6fbMt8uOQXB9UNe1b9bsT3KMEVX3HOSAkejS/aBTpXdiF1Jqo7wZM=;
Message-ID: <85179.49541.qm@web180301.mail.gq1.yahoo.com>
X-YMail-OSG: wLlqF44VM1nle.aBQhSxPn.rsM9TzFOpFKEPGktmJDcfs0B
 HlqLoFo9l64kNRVDWN.N6aewEHMv.tv3KI1jFRmXNb0r54tsOYBwEoJ1YMfn
 q3OlDBZ_8BP4j.wl3wmy_n0GLP.6sFWE_x5Pki6g7IPhXf_KuMRfAqKQYdsR
 39tKByL1w1xg1t9muSUR_a.6.am01F6Ulcjnq8JyieTzE3HLYJeGTGmDC3HX
 yKmRl28WWR11nogQCtfNL99nm9tXioJvIUQeO51mCHsOs4UXJVTjHhK2P031
 zpqifgUn8Lo2GTSYnMj4QUdVIJe1v7.php5v6hDOi
X-Mailer: YahooMailClassic/11.2.4 YahooMailWebService/0.8.105.279950
Date: Sun, 1 Aug 2010 16:19:21 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread
To: "Ted Ts'o" <tytso@mit.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: peterz@infradead.org, swetland@google.com, linux-kernel@vger.kernel.org,
        florian@mickler.org, linux-pm@lists.linux-foundation.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk, Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <201008020102.24674.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> be "trusted" on some systems and they may not be "trusted"
> on some other
> system, depending on the configuration etc.

Yes, let's reserve "trusted" for security contexts.
One might view agressively bad power management as
a security threat, of course:  when the machine
becomes unavailable because its battery dies, that
can be viewed as a security attack, since keeping the machine available is the primary security goal.

Distinguish bugs from broken-by-design, too.

- Dave


