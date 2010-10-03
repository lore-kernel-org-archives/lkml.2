Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab0JCTg3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 15:36:29 -0400
Received: from n3-vm0.bullet.mail.gq1.yahoo.com ([67.195.23.156]:28245 "HELO
	n3-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751597Ab0JCTg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 15:36:28 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 837984.42669.bm@omp127.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=V5tY8iC3qZtcaKvB3zbHhjo+llXCfwm+csnJ4cq11zYcXZOSBHrNeaOn/q4STj44Fm6xB/3wM9jZivlSZnObl2VhnzjWbtInQ7hlouEMCXsol52vJFOMkq9G78UhWsJe76T2NeVT80aC9D00rnJ1ltUDNR8ocui8iysDgBXeMQU=;
Message-ID: <594730.42296.qm@web180308.mail.gq1.yahoo.com>
X-YMail-OSG: OvoRy18VM1n.qypiFcSf0gkmxTArRjlKVh9gOUnaqeA28mw
 e_42SxJd_ukhbaf0HUQ5tKhFo_jp2At2H7_PHU2q3uWkYHIWMMs2zxHNQpAB
 CTfItP7_exVW.LrkNTB1YM9tQFRjB9HYs.GNjXFxv2dqtEXOP0U.K4WXXx3o
 Nc0AfthLxuhMQlo1JR__sjswJFrJUhVKZSAu8dzODltZkeNlw.MNtHReWKPm
 11VCR87trIFfnuDBWzsVZGyLtN9XgWc2G4LSy4590g1hsbUNtaM43PVTLPTK
 3AvThZ0FiWI1Nz68erLgOwCGIaYkRpgg2E1bj3_3DNsKWp3jfvwcD_2E-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.105.279950
Date: Sun, 3 Oct 2010 12:36:27 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [RFC/PATCH 2/2] usb:gadget: Add SuperSpeed support to the Gadget Framework
To: linux-usb@vger.kernel.org, tlinder <tlinder@codeaurora.org>
Cc: Tatyana Linder <tlinder@codeaurora.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Robert Lukassen <robert.lukassen@tomtom.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Fabien Chouteau <fabien.chouteau@barco.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1286092937-29191-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I seem to have missed any posting of a SuperSpeed
capable USB Device Controller driver, even as RFC.

So these patches can't actually achieve what their
subjects say.

I'd rather hold off such interface changes until
there's a orking vertical slice through the stack,
complete enough to test and evaluate the changes.

That said:  yes, propose the interface changes first
before diving into the rest.

- Dave




