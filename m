Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab2BFMKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 07:10:31 -0500
Received: from nm6.bullet.mail.ird.yahoo.com ([77.238.189.63]:39184 "HELO
	nm6.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754282Ab2BFMK3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 07:10:29 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 554105.5424.bm@omp1027.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=0HGwvKc8Kl1wYRAdGJ+TDlJ7y24XkhGUskrcjHHVQ9SloPQkA9pA2AzjD+Fz+KT9fPfMreSgONcUWlT1wz1iaNiq5r+xqPLFdIQHPKrPzhcNIQNj8/LGEIVQPZBJPHZYKkQEnnloeEwRniHCL30zOwJsZZfYNb/NN25pvyFBU1E=;
X-YMail-OSG: T0lRVbkVM1mtgUDyaJVvVXgHwkHrReBdiUqBAUCOsHs.FLy
 RXX2b0RsFw86TC6pUMn99cgqyAatLK7e3R95_vFP9BjVRtdqmVqNb.kr6u93
 4qqQzDZ.iWYBuN9GEI_IzBbEZYhFkBCIPsSsl2n5.SMrQH5qvQPKkMv._7dR
 7Y6VuiJ7aD6J6aZ6H5QvosLCWnUPfc6m6rbNUzq0A48VdSFIjL_VMCnMJopl
 eolymeOL4yoIfgtX3Y7qvuavWA.jvI58RFBeTenyO_5Q2qedVqOXd1lSC5c_
 2JVliMY9qCbfarC3L0lMhe8obEMTVvrNHuED24hj3_kuL6rhsUaDrmdJvL4E
 0JypSlgQtbtcqWJXG2piKO4W0MEf9DAC62YaQOIqSHe37MkrP3OfdvJKYRUg
 7512tO7vQUok1Vy3q_h3LSiZSwsTezcm9iXS_f598akp_Xceu8_pwEA--
X-Mailer: YahooMailClassic/15.0.4 YahooMailWebService/0.8.116.331537
Message-ID: <1328530227.72508.YahooMailClassic@web29004.mail.ird.yahoo.com>
Date: Mon, 6 Feb 2012 12:10:27 +0000 (GMT)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: Re: No /dev/root with devtmpfs?
To: linux-kernel@vger.kernel.org, Kirill Smelkov <kirr@mns.spb.ru>
Cc: Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <20120206111853.GA11506@tugrik.mns.mnsspb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 6/2/12, Kirill Smelkov <kirr@mns.spb.ru> wrote:
> Is it somehow possible to add /dev/root to devtmpfs?

Or alternatively have /proc/mounts report the actual root device
instead of "/dev/root" ?
