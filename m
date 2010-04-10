Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab0DJW6X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 18:58:23 -0400
Received: from smtp107.sbc.mail.gq1.yahoo.com ([67.195.14.110]:23472 "HELO
	smtp107.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752371Ab0DJW6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 18:58:22 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Apr 2010 18:58:21 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3HtlXJ6bZ/KLkC5wlREo5Yxr7Kl9CgXs3W1sbIa1iv1B/eYtQDHUbAoBNZadYKrgFWXaRgPGJzm1m0gzH9Ti/MpPs0FHFeG5yyhBgQ5DkL92FWp3aYHG8v/i45gWgOQVIjIMNqHWkvlr/cNnRwqb6THoJ/Mm21JMO0cuy3XC2gI=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: WrOmhDwVM1lKB3Abq_.eyngBnoSP3045LQFxh853DPHM9uIUCaxJ.NYeKVmZSFBYtafxuXzJNHVh0BSm2PpuK05zOzP3aGA.ecXuqR_5mc2tLYmkZaHGyVPhw310i0Z7RIAogzW5LRaKuM.k.uq5WmYF7sjt7lhHCAelB3yk5tjNNTY7ab1cwexHS2cpXw1PKNN5F0dgLQUdsDGG_rW.rhsmm.Xyi0CrN49YzpufS9Y89UdlHSZiJ6xq3Y.HKHljW.TzrZ.0noVhXj8NdHNiDPFdu8sLCqDLuOZp7ZnTmlGY0U0gFuCRcnI-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv2 7/8] USB: testusb: an USB testing application
Date: Sat, 10 Apr 2010 15:51:40 -0700
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>,
       Greg KH <greg@kroah.com>, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
References: <cover.1270835924.git.mina86@mina86.com> <20100408002952.GC4365@kroah.com>  <bc9d1ab4bd3fc9a3dfa3792054cfb410cf9c6411.1270835924.git.mina86@mina86.com>
In-Reply-To: <bc9d1ab4bd3fc9a3dfa3792054cfb410cf9c6411.1270835924.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004101551.40418.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 April 2010, Michal Nazarewicz wrote:
> > I also would like to get an ack from David that he doesn't mind his code
> > moving into the kernel here (personally I think it's a good thing to be
> > here.)


Fine by me.  It might seee more miprovements this way too.

