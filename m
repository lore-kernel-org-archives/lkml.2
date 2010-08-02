Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab0HBL0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 07:26:09 -0400
Received: from n3-vm0.bullet.mail.gq1.yahoo.com ([67.195.23.156]:46601 "HELO
	n3-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751393Ab0HBL0H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 07:26:07 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 213709.55899.bm@omp130.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=K/eye0cyUP8zdzJ4j3JOAyzL2Upd6dA2yRg11+P5Vx99NrrBVcxZp/AgABArDsjNJKlMEf2k2oTzo10AHKfbbz+dfdRhfnvdXKZwkqrwcDO5z4eQqbuRBbszi+jkMvLzkr1gZZ4YnVgTAj5yDRKwhF6Fa7tT0yqnQTkvKLiTrhk=;
Message-ID: <28603.82914.qm@web180301.mail.gq1.yahoo.com>
X-YMail-OSG: JKUubBkVM1n7ukqZVCOR3j5PRwEZZZwXT14rv7lewVTWOV9
 juzop5LSUl5T.DuezWmvhOxxOZULNwSYqzTZjCeT3bllZQFGFZJeQrgacfDO
 FnrvaB8pQ_uVhtLSmX743U5Rq3Gluav_Z.TO_kWi3.7ACTSxV_tBJHF5fQTw
 opF_2q6osHU.fDqh7GkWxjfAbJn5VUaCRvX0SzXMNaoQCfpYCK99E_13vD8g
 5t1Ec73JgLiP_X7bDPPdbASMAX4ajeBGdXiA20ojNLQbtSwWdbOBAZ6NFfZ_
 KuFlcqXuL3gOA8GykHoF92snjpNMqnB38.lPpTA--
X-Mailer: YahooMailClassic/11.2.4 YahooMailWebService/0.8.105.279950
Date: Mon, 2 Aug 2010 04:26:05 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCHv5 1/3] USB: gadget: composite: Better string override handling
To: Greg KH <greg@kroah.com>,
        =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
In-Reply-To: <op.vgs1ipl47p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > NAK.  You're still hard-wiring an un-managed
> serial number.
> 
> Uh?  I'm not.

Are too.  THere's a line assigning such an
un-managed number.  Get rid of it instead of
denying its existence (and then justifying it).




