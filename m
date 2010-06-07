Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab0FGSkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:40:37 -0400
Received: from n6-vm0.bullet.mail.gq1.yahoo.com ([98.137.26.79]:39735 "HELO
	n6-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751580Ab0FGSkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:40:35 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 929905.68507.bm@omp127.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=mqOn0o/Zsad6g3VlXC02po4+JJbt28/9k8OK5S7grbsittV83SkzIHl+cSIc6H9GkJ8SsLln9AF759ct3GJw7dUUAAnL2LBNpp2EPy+K0chs7ysECF/60+WIyADUo8hMgLcWrKaBXg1LzkZyVlYgdYpwmp83CXXLTQQKd6GRkN8=;
Message-ID: <768161.83147.qm@web180312.mail.gq1.yahoo.com>
X-YMail-OSG: OCakp24VM1nXTHTRV9x2HlFwFE.Xr4bHCIoUJTjTikCVLtv
 jHE59FDAU7nG_N6.2n4p25HfDkmA7XA9se6VwMdnFMc0Gm6ugt2LcKogSpRA
 fKq5XodQc9IiEHY6mg2CvEfHoRVeWC9CNYZPYLiNh_EmCf4fafJSd.IaFB4a
 j090bjo1kD.LuFwW5_xy6dpUhQucaYcv9ebcq7EuMaI9fTDNjIGBfidHZNpV
 uPmqnVIkf5cmyiq_.VoR7kQKvqkdwfK_lHrnHbJMg6OmeHPYD5Aqc1Ymunnu
 MIOWuXd3TlD5EuzD9nNmagwtVFgc6ZOpekPeqe9Yh5M.V13hfTe4FkLg7DXA
 Y6nKN9SDMofPVfUBVb7kbtE6D3FyzipNq
X-Mailer: YahooMailClassic/11.0.8 YahooMailWebService/0.8.103.269680
Date: Mon, 7 Jun 2010 11:40:34 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] suspend blockers & Android integration
To: Brian Swetland <swetland@google.com>,
       Peter Zijlstra <peterz@infradead.org>
Cc: tytso@mit.edu, Neil Brown <neilb@suse.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Christoph Hellwig <hch@infradead.org>,
       Florian Mickler <florian@mickler.org>,
       James Bottomley <James.Bottomley@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1275916830.1645.566.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Mon, 6/7/10, Peter Zijlstra <peterz@infradead.org> wrote:
> So what's up with this Binder stuff, from what I can see
> its just
> yet-another-CORBA. Why does it need a kernel part at all,
> can't you
> simply run with a user-space ORB instead?
> 
> I really don't get why people keep re-inventing CORBA,


That made me laugh.  Do you realize that one
of the earliest objections to CORBA was "why do
people keep re-inventing RPC" ...  :)

(Simple answer:  the existing stuff didn't solve
enough of the right problems ... and it was easier
(in a political sense) to come up with something
new than to try fixing DCE or ONC (or whatever).
Similar answers may still apply ... last I looked
at CORBA, it didn't standardize desktop integration
(or cell-phone equivalents), and the pure user-space
versions suffered slowdowns when looking up object
bindings.


> there's some really nice (free) ORBs out there,

